# docx2gfm - docx to github-flavored-markdown converter

If you need to convert `.docx` documents to markdown, then **docx2gfm** is for you, as it makes the process faster.

`docx2gfm` turns [this docx file](./examples/sample.docx) into [this markdown](./examples/sample.md). (also see the original [google Doc][gDoc])

So while some post-processing of the markdown is still required, `docx2gfm` already makes the conversion process much faster.

## The Long Story

I am maintaining an engineering blog, that uses [jekyll][jekyll] to generate static pages.

In our blogging process, the authors write blog post as a Google Doc to collect feedback. Once the post is ready for publishing, they convert the Google Doc to [github-flavored-markdown][gfm], as that is what [jekyll][jekyll] needs as input to render the HTML for the blog.

We used to do this conversion step manually. This was tedious, boring, and in parts error-prone.

With `docx2gfm` you can do this conversion quickly, and have more time to write new blog posts ... or drink coffee :)

Technically `docx2gfm` is a thin wrapper around [pandoc][pandoc]. In [MOTIVATION.md](./MOTIVATION.md) you find more about the technical approach we chose.

## Installation

- install ruby
- install [pandoc][pandoc]
- install this gem: `gem install docx2gfm`

## Usage

1. download your Google Doc as a `.docx` file e.g. `my_post.docx` (File >> Download as >> Microsoft Word (.docx))
1. convert docx to github-flavored-markdown:

```
docx2gfm -f my_post.docx > my_post.md
```

To learn more about the available options please refer to the built-in help.

```
$ docx2gfm -h

Usage: docx2gfm [options]
    -f, --file FILE                  (required) The .docx file to convert to markdown
    -j, --[no-]jekyll                (optional) Prefix the markdown output with a jekyll frontmatter. Default: --jekyll
    -r, --[no-]ref-style-links       (optional) Create reference style links at the end of the markdown. Default: --ref-style-links
    -h, --help                       Display this help screen
```

## Finishing touches for your markdown

The markdown produced by `docx2gfm` is good but not perfect. You still have to do some manual steps:

* Adapt the YAML Frontmatter (if you used the `--jekyll` option)
* Add the correct image links
* Add code blocks
* Add quotes
* Add tables

## Alternatives to docx2gfm

* Word to Markdown Converter: [online](https://word-to-markdown.herokuapp.com/), [source](https://github.com/benbalter/word-to-markdown)
* [Writage](http://www.writage.com) - Markdown plugin for Microsoft Word

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

`docx2gfm` is far from perfect.
Bug reports and pull requests are welcome on GitHub at https://github.com/spier/docx2gfm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[uth]: https://underthehood.meltwater.com/
[gfm]: https://guides.github.com/features/mastering-markdown/
[gDoc]: https://docs.google.com/document/d/16Kww2ic-YgFKskfDxYJu6o_ooSF3IORJh8Ho7XbgngI/edit
[pandoc]: https://pandoc.org/installing.html
[jekyll]: https://jekyllrb.com
