# docx to github-flavored-markdown converter

When creating blog posts we first create them as a google doc to make the collaboration during the editorial process easier. Before publishing the post to [underthehood.meltwater.com][uth] we need to convert the google doc to [github-flavored-markdown][gfm], as that is what our jekyll-based blog uses.

This conversion step is tedious, boring, and some parts are error-prone.

With `docx2gfm.rb` you can do this conversion quickly, and have more time to write new blog posts ... or drink coffee :)

# Example

docx2gfm is not flawless yet, but it turns [this docx file](./examples/sample.docx) into [this markdown](./examples/sample.md). (also see [gDoc][gDoc])

So while some post-processing of the markdown is still required, it already makes the conversation process much faster.

# Installation

- install [pandoc][pandoc]
- install ruby (if you don't have it already)
- Done :)

# How to convert a gdoc

1. reduce headlines of your gdoc to levels h2 and below. In our blog, h1 is reserved for the title of the blog post
1. download your gdoc as a .docx file e.g. my_post.docx (File >> Download as >> Microsoft Word (.docx))
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

# Finishing touches to your markdown

The markdown produced by docx2gfm is good, but it is not 100% polished. You still have to do some manual steps:

* Double-check that all content is there, especially at the beginning of the post (we got a [known bug about this](https://github.com/meltwater/docx2gfm/issues/6))
* Add the correct image links
* Add code blocks
* Add quotes

# How to contribute

docx2gfm is far from perfect. Help us make it better by filing an issue or sending a pull request.

# References

* [further options](https://github.com/meltwater/meltwater.github.com/issues/104) to create markdown
* Word to Markdown Converter: [online](https://word-to-markdown.herokuapp.com/), [source](https://github.com/benbalter/word-to-markdown)
* [Writage](http://www.writage.com) - Markdown plugin for Microsoft Word

# Why use docx2gfm, instead of using pandoc straight up?

docx2gfm is a wrapper around [pandoc][pandoc], which does the heavy-lifting of the docx to markdown conversation.
So why not use pandoc straight up you may ask?

The best pandoc configuration that I could find so far is this:

```
pandoc examples/sample.docx --wrap=none --atx-headers --reference-links -f docx -t markdown-bracketed_spans-link_attributes -s
```

It produces the markdown output as shown in [examples/sample-pure-pandoc.md](./examples/sample-pure-pandoc.md).

While this is pretty good already, this markdown has the following shortcomings:

* lists have some spaces before each list item
* HTML formatting for underlines is created e.g. `<span class="underline">In mattis lectus</span>` => one could use something similar to `sed -e 's/<[^>]*>//g'` to get rid of the HTML. however this will also remove the HTML placeholders for the images
* less pretty reference-links at the end of the file


# Maintainer

Sebastian Spier


# TODO

- look for docx2md online. maybe something that I can use?
	https://gist.github.com/vzvenyach/7278543

[uth]: https://underthehood.meltwater.com/
[gfm]: https://guides.github.com/features/mastering-markdown/
[gDoc]: https://docs.google.com/document/d/1oKGYVORih0GNC1CZHKv0d2IirCtcgMu0O1sifTfH5zo/edit
[pandoc]: https://pandoc.org/installing.html
