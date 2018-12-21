# docx to github-flavored-markdown converter

When creating blog posts, we typically create them as a google doc, to make collaboration on the content easier.
Before publishing the post to underthehood.meltwater.com we need to convert the google doc to github-flavored-markdown, as that is what our jekyll-based blog uses.

This step is tedious, and some parts are error-prone.

With `docx2gfm.rb` you can do this quickly, and have more time to drink coffee :)

# Example

md-convert is not flawless yet, but it turns [this docx file](./examples/sample.docx) into [this markdown](./examples/sample.md). (also see [gDoc][gDoc])

So while some post-processing of the markdown is still required, it already makes the conversation process faster.

# Installation

1. install [pandoc](https://pandoc.org/installing.html)
1. install the ruby dependencies via `bundle install`

# How to convert a gdoc

1. reduce headlines of your gdoc to levels h2 and below. In our blog, h1 is reserved for the title of the blog post
1. download your gdoc as a .docx file e.g. my_post.docx (File >> Download as >> Microsoft Word (.docx))
1. convert gdoc to github-flavored-markdown:

		ruby docx2gfm.rb my_post.docx > my_post.md

# Finishing touches to your markdown

The markdown produced by docx2gfm is good, but it is not 100% polished. You still have to do some manual steps:

* Double-check that all content is there, especially at the beginning of the post (we got a [known bug about this](https://github.com/meltwater/docx2gfm/issues/6))
* Add the correct image links
* Add code blocks
* Add quotes

# References

- further options to create markdown
https://github.com/meltwater/meltwater.github.com/issues/104

# TODO

- look for docx2md online. maybe something that I can use?
	https://gist.github.com/vzvenyach/7278543

[gDoc]: https://docs.google.com/document/d/1oKGYVORih0GNC1CZHKv0d2IirCtcgMu0O1sifTfH5zo/edit
