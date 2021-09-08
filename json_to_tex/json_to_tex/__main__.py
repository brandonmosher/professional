#!/usr/bin/env python3

import json_to_tex as jtt
import json
import sys
from pathlib import Path

import argparse
parser = argparse.ArgumentParser()

parser.add_argument(
    'filepaths',
    type=Path,
    nargs='+',
    help='Filepaths to text template and JSON files. JSON files will be merged in the order specified from left to right.')

parser.add_argument(
    '--output-dirpath',
    type=Path,
    default=Path('.'),
    help='Output directory for generated files. Default is current directory.')

parser.add_argument(
    '--output-filestem',
    type=str,
    help='Specifies a stem that will be used to named output files. If not specified, tex_template_filepath stem is used.')

parser.add_argument(
    '--include-tags',
    nargs='*',
    help='Only JSON entries matching the specified tags or entries with no tags specified will be processed.')

parser.add_argument(
    '--exclude-tags',
    nargs='*',
    help='Only JSON entries NOT matching the specified tags or entries with no tags specified will be processed.')

parser.add_argument(
    '--no-prune-property-names',
    nargs='*',
    default=[],
    help='A list of property names that will not be pruned from the JSON data whether or not it is used in the tex template.')

parser.add_argument(
    '--json-merge-property-name',
    type=str,
    help='The property values associated with property name are compared to determine the equality of two JSON objects when their equality cannot be inferred by the hierarchical structure.')

parser.add_argument(
    '--json-sort-property-name',
    type=str,
    help='The property values associated with property name are compared to determine the ordering of two JSON objects when their order cannot be inferred by the hierarchical structure.')

def filter_filepaths_by_file_suffix(filepaths, file_suffix):
    return [filepath for filepath in filepaths if filepath.suffix == file_suffix]

def main():
    args = parser.parse_args()
    tex_template_filepath = filter_filepaths_by_file_suffix(args.filepaths, '.tex')
    json_filepaths = filter_filepaths_by_file_suffix(args.filepaths, '.json')

    if len(tex_template_filepath) > 1:
        sys.exit('Only one tex template may be specified. You specified: {}'.format(' '.join(tex_template_filepath)))
    else:
        tex_template_filepath = tex_template_filepath[0]
    
    if not len(args.output_filestem):
        args.output_filestem = tex_template_filepath.stem
    
    template = jtt.generate_template(tex_template_filepath)
    # import pprint
    # pp = pprint.PrettyPrinter()
    # pp.pprint(template)

    merge_comp = None
    if(args.json_merge_property_name):
        merge_comp = lambda v_cur, v_new: isinstance(v_cur, dict) and (args.json_merge_property_name in v_cur) and isinstance(v_new, dict) and (args.json_merge_property_name in v_new) and (v_cur[args.json_merge_property_name] == v_new[args.json_merge_property_name])
    
    merge_sort_key = None
    if(args.json_sort_property_name):
        merge_sort_key = lambda obj : (args.json_sort_property_name not in obj, obj.get(args.json_sort_property_name, None))

    merged_json = {}
    for json_filepath in json_filepaths:
        jtt.merge_obj(merged_json, jtt.load_json(json_filepath), merge_comp=merge_comp, sort_key=merge_sort_key)
    
    def filter_func(target_tags, include):
        def f(value):
            if not isinstance(value, dict):
                return True
            
            if 'tags' not in value:
                return True
            
            tags = value['tags']

            property_only_tags = set()
            if isinstance(tags, dict):
                for tag, properties in tags.items():
                    if isinstance(properties, list) and len(properties):
                        property_only_tags.add(tag)
                
            for property_only_tag in property_only_tags:
                for property in tags[property_only_tag]:
                    if (property_only_tag in target_tags) and (property in value):
                        if include:
                            # Not sure that there is a symmetrical case for include tags
                            pass
                        else:
                            del value[property]

            if len(tags) == len(property_only_tags):
                return True
            
            if any([(tag in tags) and (tag not in property_only_tags) for tag in target_tags]):
                return include
            
            return not include
        
        return f

    if(args.include_tags):
        jtt.filter_obj(merged_json, filter_func(args.include_tags, True))

    if(args.exclude_tags):
        jtt.filter_obj(merged_json, filter_func(args.exclude_tags, False))
    
    jtt.prune_obj(merged_json, template, no_prune_property_names=args.no_prune_property_names)

    args.output_dirpath.mkdir(parents=True, exist_ok=True)

    with open(args.output_dirpath.joinpath(''.join((args.output_filestem, '.json'))), 'w+') as file:
        json.dump(merged_json, file)
    
    with open(args.output_dirpath.joinpath(''.join((args.output_filestem, '.tex'))), 'w+') as file:
        tex = jtt.json_to_tex(merged_json, template)
        tex = jtt.remove_empty_environments(tex)
        file.write(tex)

if __name__ == '__main__':
    main()