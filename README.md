# sticks: a dead simple static site generator

`sticks` is a tiny and customizable static site generator.

it leverages [hakyll](https://jaspervdj.be/hakyll/) and [pandoc](https://pandoc.org/) to great extent, and so checks in at just under 50 lines of haskell.

### features

- html templating: directly through pandoc
- support for markdown, restructured text, asciidoc, org-mode...
- [todo] renders latex and typst directly to pdfs
- supports pandoc flavoured markdown, including:
  - lists with meaningful numeric order
  - line blocks and nested quotes
  - code blocks <!-- and syntax highlighting -->
  - a wide variety of tables
  - inline latex via mathml
  - yaml metadata blocks

### usage

```bash
$ stack build
$ stack exec sticks -- --help
Usage: sticks [-v|--verbose] COMMAND

  sticks - Static site compiler created with Hakyll

Available options:
  -h,--help                Show this help text
  -v,--verbose             Run in verbose mode

Available commands:
  build                    Generate the site
  check                    Validate the site output
  clean                    Clean up and remove cache
  rebuild                  Clean and build again
  server                   Start a preview server
  watch                    Autocompile on changes and start a preview server.
```

### about

pandoc (and by extension hakyll and sticks) operates on:
- **files** containing *metadata* and *content*, and
- **templates** containing *variables* and *expressions*.

files may be prefixed with a YAML metadata block ("front matter") declaring variables (ex. title, subtitle, author...) for use by *templates*. a special `template` variable denotes the template to be used. without a `template` entry in the metadata block, they will be assumed to be free-standing documents (disregarding YAML front matter).

templates are simply an html, or pdf, or etc file containing the content needed (ex. header and footer material) for a free-standing document. they must contain the special `$body$` variable somewhere for file injection. they may refer to variables declared by files with `$variable$`. basic control flow is also supported and is documented in [the pandoc manual](https://pandoc.org/MANUAL.html#template-syntax) (note only the `$foo$` syntax is supported, not `${foo}`).

sticks expects all templates to be placed in the `_templates` folder and will throw an error for any templates referenced by front matter that do not exist there. templates may include each other with the `$partial("_template/template.html")$` syntax.

the aforementioned YAML metadata blocks may be placed before files of any type. they look like the following:
```yaml
---
template: default
title: a really cool document
subtitle: https://www.youtube.com/watch?v=dQw4w9WgXcQ
---
```
