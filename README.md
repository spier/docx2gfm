# docx to github-flavored-markdown converter

For quite a while I have been the maintainer/editor of the engineering blog [underthehood.meltwater.com][uth]. The authors wrote their drafts as Google Docs, and then eventually needed to convert the google doc to [github-flavored-markdown][gfm], as that is what the [jekyll](https://jekyllrb.com)-based blog uses.

This conversion step is tedious, boring, and some parts are error-prone.

With `docx2gfm.rb` you can do this conversion quickly, and have more time to write new blog posts ... or drink coffee :)

Technically `docx2gfm.rb` is a thin wrapper around [pandoc][pandoc]. Read more about the [motivation](./MOTIVATION.md) here.

## Example

docx2gfm is not flawless, but it turns [this docx file](./examples/sample.docx) into [this markdown](./examples/sample.md). (also see the original [google Doc][gDoc])

So while some post-processing of the markdown is still required, it already makes the conversation process much faster.

## Installation

- install [pandoc][pandoc]
- install ruby
- Done :)

## How to convert a gdoc

1. download your gdoc as a `.docx` file e.g. `my_post.docx` (File >> Download as >> Microsoft Word (.docx))
1. convert docx to github-flavored-markdown:

```
ruby docx2gfm.rb -f my_post.docx > my_post.md
```

To learn more about the available commandline options please refer to the built-in help.

```
ruby docx2gfm.rb -h		

Usage: docx2gmf.rb [options]
-f, --file FILE                  (required) The .docx file to convert to markdown
-j, --[no-]jekyll                (optional) Prefix the markdown output with a jekyll frontmatter. Default: --jekyll
-r, --[no-]ref-style-links       (optional) Create reference style links at the end of the markdown. Default: --ref-style-links
-h, --help                       Display this help screen
```

## Finishing touches for your markdown

The markdown produced by docx2gfm is good, but it is not 100% polished. You still have to do some manual steps:

* Adapt the YAML Frontmatter (if you used the `--jekyll` option)
* Add the correct image links
* Add code blocks
* Add quotes
* Add tables

## How to contribute

docx2gfm is far from perfect. Help us make it better by filing an issue or sending a pull request.

## Alternatives to docx2gfm

* Word to Markdown Converter: [online](https://word-to-markdown.herokuapp.com/), [source](https://github.com/benbalter/word-to-markdown)
* [Writage](http://www.writage.com) - Markdown plugin for Microsoft Word

[uth]: https://underthehood.meltwater.com/
[gfm]: https://guides.github.com/features/mastering-markdown/
[gDoc]: https://docs.google.com/document/d/16Kww2ic-YgFKskfDxYJu6o_ooSF3IORJh8Ho7XbgngI/edit
[pandoc]: https://pandoc.org/installing.html
