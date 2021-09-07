import json
import re
from pylatexenc.latexwalker import LatexWalker, LatexEnvironmentNode, LatexGroupNode
from collections import defaultdict
from pathlib import Path

def clean(text):
    lines = []
    for line in text.splitlines():
        line = line.strip()
        if len(line) and line[0] != '%':
            lines.append(line)
    return '\n'.join(lines)

def escape_python(template):
    template = re.sub(r'{', '{{', template)
    template = re.sub(r'}', '}}', template)
    template = re.sub(r'(\\p{{)([^}]+|)(}})', r'{\2}', template)
    return template

def escape_tex(text):
    """
        :param text: a plain text message
        :return: the message escaped to appear correctly in LaTeX
    """
    conv = {
        '&': r'\&',
        '%': r'\%',
        '$': r'\$',
        '#': r'\#',
        '_': r'\_',
        '{': r'\{',
        '}': r'\}',
        '~': r'\textasciitilde{}',
        '^': r'\^{}',
        '\\': r'\textbackslash{}',
        '<': r'\textless{}',
        '>': r'\textgreater{}',
        '\n': r'\\'
    }
    regex = re.compile('|'.join(re.escape(str(key)) for key in sorted(conv.keys(), key = lambda item: - len(item))))
    return regex.sub(lambda match: conv[match.group()], text)

def get_latex_environment_node(environmentname, nodelist):
    for node in nodelist:
        if isinstance(node, LatexEnvironmentNode) and node.environmentname == environmentname:
            return node
        elif isinstance(node, (LatexEnvironmentNode, LatexGroupNode)):
            current = get_latex_environment_node(environmentname, node.nodelist)
            if current:
                return current
    return None

def split_preamble_and_document(text):
    (preamble, document) = text.split("\\begin{document")    
    document = "\\begin{{document}}{}".format(document)
    return preamble, document

def inner_latex_verbatim(node):
    output = []
    for inner_node in node.nodelist:
        output.append(inner_node.latex_verbatim())
    return ''.join(output)

def remove_empty_environments(input):
    if isinstance(input, Path):
        with open(input, 'r') as file:
            input = file.read()
    
    preamble, document = split_preamble_and_document(input)

    latex_walker = LatexWalker(document)
    (nodelist, _, _) = latex_walker.get_latex_nodes(pos=0)
    document = remove_empty_environments_helper(nodelist)

    return '{}{}'.format(preamble, document)

def remove_empty_environments_helper(nodelist):
    output = ""
    for node in nodelist:
        if isinstance(node, LatexEnvironmentNode):
            if inner_latex_verbatim(node).strip() == "":
                pass
            else:
                output += '\\begin{{{0}}}{1}\\end{{{0}}}'.format(node.environmentname, remove_empty_environments_helper(node.nodelist))
        elif isinstance(node, LatexGroupNode):
            output += '{{{}}}'.format(remove_empty_environments_helper(node.nodelist))
        else:
            output += node.latex_verbatim()
    return output

def filter_obj(obj, func):
    it = obj.items() if isinstance(obj, dict) else enumerate(obj)
    to_remove = []
    for key, value in it:
        if not func(value):
            to_remove.append([key, value])
        elif isinstance(value, (dict, list)):
            filter_obj(value, func)

    for key, value in to_remove:
        if isinstance(obj, dict):
            obj.pop(key)
        elif isinstance(obj, list):
            obj.remove(value)

def merge_obj(a, b):
    for key, value in b.items():
        if key not in a:
            a[key] = value
        elif isinstance(value, dict):
            merge_obj(a[key], value)
        elif isinstance(value, list):
            a[key] += value
        else:
            a[key] = value

def map_obj(obj, func):
    it = obj.items() if isinstance(obj, dict) else enumerate(obj)
    for key, value in it:
        if isinstance(value, (dict, list)):
            map_obj(value, func)
        else:
            obj[key] = func(value)

def prune_obj(obj, template):
    if(isinstance(obj, dict)):
        keys_to_delete = set()
        for key, value in obj.items():
            if key in template:
                prune_obj(value, template[key])
            elif '{{{}}}'.format(key) in template['template']:
                pass
            else:
                keys_to_delete.add(key)
        for key in keys_to_delete:
            del obj[key]
    elif(isinstance(obj, list)):
        for i, value in enumerate(obj):
            if(isinstance(value, dict)):
                prune_obj(value, template)

def reduce_obj(obj, template):
    if(isinstance(obj, dict)):
        for key, value in obj.items():
            if(isinstance(value, (dict, list))):
                if key in template:
                    obj[key] = reduce_obj(value, template[key])
        return template['template'].format_map(defaultdict(str, obj))
    elif(isinstance(obj, list)):
        for i, value in enumerate(obj):
            if(isinstance(value, dict)):
                obj[i] = reduce_obj(value, template)
            else:
                obj[i] = template['template'].format(value)
        return "\n".join(obj)


def generate_template_helper(nodelist):
    output = {'template': ''}
    for node in nodelist:
        if isinstance(node, LatexEnvironmentNode):
            nodelist = node.nodelist
            environment_args = ""
            if isinstance(nodelist[0], LatexGroupNode):
                environment_args = node.nodelist[0].latex_verbatim()
                nodelist = nodelist[1:]
            output['template'] += '\\begin{{{0}}}{1}\n\\p{{{0}}}\n\\end{{{0}}}'.format(node.environmentname, environment_args)
            output[node.environmentname] = generate_template_helper(nodelist)
        elif isinstance(node, LatexGroupNode) and len(node.nodelist) > 1:
            tmp = generate_template_helper(node.nodelist)
            template = '{}{{{}}}'.format(output['template'], tmp['template'])
            output = {**output, **tmp, 'template': template}
        else:
            output['template'] += node.latex_verbatim()
    output['template'] = output['template'].strip()
    return output

def generate_template(input):
    if isinstance(input, Path):
        with open(input, 'r') as file:
            input = file.read()
        
        input = clean(input)
        preamble, document = split_preamble_and_document(input)

        latex_walker = LatexWalker(document)
        (nodelist, _, _) = latex_walker.get_latex_nodes(pos=0)
        output = generate_template_helper(nodelist)
        map_obj(output, escape_python)

        preamble = escape_python(preamble)
        preamble = "{}\\begin{{{{document}}}}\n{{document}}\n\\end{{{{document}}}}".format(preamble)
        output['template'] = preamble
        
        return output

def load_json(filepath):
    with open(filepath) as file:
        return json.load(file)

def json_to_tex(json, template):
    if isinstance(json, (str, Path)):
        json = load_json(json)
    map_obj(json, escape_tex)
    if isinstance(template, (str, Path)):
        template = generate_template(template)
    return reduce_obj(json, template)