# Resume

## json_to_tex

### Installation
```
pip install ./json_to_tex
```

### Usage
```
json_to_tex [-h] [--output-dirpath OUTPUT_DIRPATH]
                   [--output-filestem OUTPUT_FILESTEM]
                   [--include-tags [INCLUDE_TAGS ...]]
                   [--exclude-tags [EXCLUDE_TAGS ...]]
                   filepaths [filepaths ...]
```
#### Positional Arguments
```
  filepaths             Filepaths to text template and JSON files. JSON files
                        will be merged in the order specified from left to
                        right.
```
#### Optional Arguments
```
  -h, --help            show this help message and exit

  --output-dirpath OUTPUT_DIRPATH
                        Output directory for generated files. Default is current directory.

  --output-filestem OUTPUT_FILESTEM
                        Specifies a stem that will be used to named output files. If not specified, tex_template_filepath stem is used.

  --include-tags [INCLUDE_TAGS ...]
                        Only JSON entries matching the specified tags or entries with no tags specified will be processed.

  --exclude-tags [EXCLUDE_TAGS ...]
                        Only JSON entries NOT matching the specified tags or entries with no tags specified will be processed.
```
## Tex Templates and JSON Files

Any tex file can be used as a template (with minor modification)s and any JSON schema will work. The only requirement is that the tex template and JSON files must have matching or partially matching hierarchical structures. This structure is specified in the tex template using nested environments and in the JSON files using nested JSON objects.

You may wish to group related content under environments. This has a couple advantages: 

1. It gives your JSON file a more logical structure

2. Property names are scoped to their containing environment/JSON object and do not need to be globally unique

Alternatively, you can use a flat JSON structure. This has the advantage of requiring no additional environments in your tex template.

Properties are inserted into the tex template using the `\p{[PROPERTY_NAME]}` macro. `[PROPERTY_NAME]` must be present in the corresponding JSON object and must exacly match the corresponding JSON object property name. If the corresponding JSON object is an array of primitive values `[PROPERTY_NAME]` should be an empty string.

Arrays in the JSON file are expanded in the tex file by applying the corresponding environment template to each element.

Objects specified in JSON file with no corresponding environment in the tex template will be ignored and will not affect the output tex file. The reverse, however, is not true. An environment in the tex template containing `\p{[PROPERY_NAME]}` macros with no corresponding JSON object will cause a compiler error since these macros are not defined.

### For example:

Note how the cventries and cvitems arrays in the JSON object are expanded in the output tex file.

### template.tex
```
\begin{document}
    \name{\p{firstName}}{\p{lastName}}
    \begin{header}
        \position{\p{position}}
        \address{\p{address}}
        \mobile{\p{mobile}}
        \email{\p{email}}
        \homepage{\p{homepage}}
        \github{\p{github}}
        \linkedin{\p{linkedin}}
        \makeheader[C]
    \end{header}
    \begin{cv}
        \begin{experience}
            \cvsection{\p{title}}
            \begin{cventries}
                \cventry
                    {\p{organization}}
                    {\p{jobTitle}}
                    {\p{location}}
                    {\p{startDate} - \p{endDate}}
                    {
                        \begin{cvitems}
                            \cvitem{\p{}}
                        \end{cvitems}
                    }
            \end{cventries}
        \end{experience}
    \end{cv}
\end{document}
```

### data.json
```
{
    "document": {
        "firstName": "Brandon",
        "lastName": "Mosher",
        "header": {
            "position": "Software Engineer",
            "address": "Brooklyn, NY",
            "mobile": "(123) 456-7890)",
            "email": "brandon@mosher.xyz",
            "homepage": "brandon.mosher.xyz",
            "github": "brandonmosher",
            "linkedin": "brandondmosher"
        },
        "cv": {
            "experience": {
                "title": "Work Experience",
                "cventries": [
                    {
                        "jobTitle": "Software Engineer",
                        "organization": "Some Company",
                        "location": "New York, NY",
                        "startDate": "Sep. 2019",
                        "endDate": "Sep. 2020",
                        "cvitems": [
                            "I built an awesome thing",
                            "And then I built another awesome thing",
                            "And so on..."
                        ]
                    }
                ]
            }
        }
    }
}
```

### Becomes

```
\begin{document}
\name{Brandon}{Mosher}
    \begin{header}
        \position{Software Engineer}
        \address{Brooklyn, NY}
        \mobile{(831) 915-8526}
        \email{brandon@mosher.xyz}
        \homepage{brandon.mosher.xyz}
        \github{brandonmosher}
        \linkedin{brandondmosher}
        \makeheader[C]
    \end{header}
    \begin{experience}
        \cvsection{Work Experience}
        \begin{cventries}
            \cventry
                {Some Company}
                {Software Engineer}
                {Overseas}
                {Sep. 2019 - Sep. 2020}
                {\begin{cvitems}
                    \cvitem{I built an awesome thing}
                    \cvitem{And then I built another awesome thing}
                    \cvitem{And so on...}
                \end{cvitems}}
        \end{cventries}
    \end{experience}
\end{document}
```

## Versions

A version file allows you to create tailored coverletters and resumes without repeating duplicate data. The version file is simply a list of arguments to be passed to json_to_tex.

### resume-front-end.version
```
resume.tex ../professional.json resume.json
--output-dirpath ../../build
--output-filestem resume-front-end
--include-tags front-end
--exclude-tags
```

## Building

The included Make automates the process of running json_to_tex and xelatex, and outputs build artifacts to the build folder.

The make command follows this format:
```
make [DOCUMENT_TYPE][VERSION].pdf
```

For example, the following command will generate `resume-front-end.tex` and `resume-front-end.pdf` and place them in the `build/resume-front-end/` directory.

```
make resume-front-end.pdf
```

For this to work, you must organize your files as shown below. Though it probably makes sense to group all of your files this way, it is only required for the version file. The tex template and json files locations are arbitrary and are specified in the version file as absolute or relative (to the version file directory) filepaths. The Makefile can, of course, be easily adapted to support other scenarios as json_to_tex makes no assumptions about file structure.

```
src/
    resume/
        resume-front-end.version
    ...
    [DOCUMENT_TYPE]/
        [DOCUMENT_TYPE]-[VERSION].version
    ...
```