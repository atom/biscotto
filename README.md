Biscotto is a [CoffeeScript](http://coffeescript.org/) API documentation generator. The underlying technology is based
entirely on [codo](https://github.com/netzpirat/codo). However, this uses [TomDoc](http://tomdoc.org/) notation instead.

Its generated documentation is focused on CoffeeScript class syntax for classical inheritance.

## Features

* Detects classes, methods, constants, mixins & concerns.
* Generates a nice site to browse your code documentation in various ways.

## Text processing

### GitHub Flavored Markdown

Biscotto documentation should be written in [GitHub Flavored Markdown](http://github.github.com/github-flavored-markdown/).

### Automatically link references

Biscotto comments and all tag texts will be parsed for references to other classes, methods and mixins, and are automatically
linked. The reference searching will not take place within code blocks, thus you can avoid reference searching errors
by surround your code block that contains curly braces with backticks.

There are several ways of link types supported and all can take an optional label after the link.

* Normal URL links: `{http://coffeescript.org/}` or `{http://coffeescript.org/ Try CoffeeScript}`
* Link to a class or mixin: `{Animal.Lion}` or `{Animal.Lion The might lion}`
* Direct link to an instance method: `{Animal.Lion#walk}` or `{Animal.Lion#walk The lion walks}`
* Direct link to a class method: `{Animal.Lion.constructor}` or `{Animal.Lion.constructor} A new king was born`

If you are referring to a method within the same class, you can omit the class name: `{#walk}`.

## Generate

After the installation you will have a `biscotto` binary that can be used to generate the documentation recursively for all
CoffeeScript files within a directory.

To view a list of commands, type

```bash
$ codo --help
```

Biscotto wants to be smart and tries to detect the best default settings for the sources, the readme, the extra files, and
the project name, so the above defaults may be different on your project.

### Project defaults

You can define your project defaults by writing your command line options to a `.biscottoopts` file:

```bash
--name       "Tomdocodo"
--readme     README.md
--title      "Tomdocodo Documentation"
--private
--quiet
--output-dir ./doc
./src
-
LICENSE
CHANGELOG.md
```

Put each option flag on a separate line, followed by the source directories or files, and optionally any extra file that
should be included into the documentation separated by a dash (`-`). If your extra file has the extension `.md`, it'll
be rendered as Markdown.

## Keyboard navigation

You can quickly search and jump through the documentation by using the fuzzy finder dialog:

* Open fuzzy finder dialog: `Ctrl-T`

In frame mode you can toggle the list naviation frame on the left side:

* Toggle list view: `Ctrl-L`

You can focus a list in frame mode or toggle a tab in frameless mode:

* Class list: `Ctrl-C`
* Mixin list: `Ctrl-I`
* File list: `Ctrl-F`
* Method list: `Ctrl-M`
* Extras list: `Ctrl-E`

You can focus and blur the search input:

* Focus search input: `Ctrl-S`
* Blur search input: `Esc`

In frameless mode you can close the list tab:

* Close list tab: `Esc`

## License

(The MIT License)

Copyright (c) 2013 Garen J. Torikian

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
