# docx to github-flavored-markdown converter

When creating blog posts, we typically create them as a google doc, to make collaboration on the content easier.
Before publishing the post to underthehood.meltwater.com we need to convert the google doc to markdown though.

This step is tedious, and some parts are error-prone.

With `docx2gmf.rb` you can do this quickly, and have more time to drink coffee :)

# Example

md-convert is not flawless yet, but it turns [this docx file](./examples/sample.docx) into [this markdown](./examples/sample.md). (also see [gDoc][gDoc])

# Installation

1. install [pandoc](https://pandoc.org/installing.html)
1. install the ruby dependencies via `bundle install`

# How to convert a gdoc

1. reduce headlines of your gdoc to levels h2 and below. In our blog, h1 is reserved for the title of the blog post
1. download your gdoc as a .docx file e.g. my_post.docx (File >> Download as >> Microsoft Word (.docx))
1. convert gdoc to github-flavored-markdown:

		ruby docx2gmf.rb my_post.docx > my_post.md

# References

- further options to create markdown
https://github.com/meltwater/meltwater.github.com/issues/104

# TODO

- look for docx2md online. maybe something that I can use?
	https://gist.github.com/vzvenyach/7278543

- bug / in sample.docx - the title of the doc is removed.
- bug / in sample.docx - the first paragraph and image is removed

- bug / underlining of text does not work. - Check: Is underlining of text even meant to work in GFM? https://help.github.com/articles/basic-writing-and-formatting-syntax/ / https://softwareengineering.stackexchange.com/questions/207727/why-there-is-no-markdown-for-underline
- bug / exclamation marks are escaped. As in `Goodbye\!` => happens in the commonmarker step
- bug / pandoc adds a funny `<!-- end list -->` sometimes
- bug / escaping of brackets by commonmaker: https://github.com/gjtorikian/commonmarker/issues/91

- create a sample gdoc with a sensible default of styling elements. use this to provide a demo of how md-convert works. https://docs.google.com/document/d/1oKGYVORih0GNC1CZHKv0d2IirCtcgMu0O1sifTfH5zo/edit

- (done) render sub-lists correctly
- (done) add jekyll YAML front matter to the very beginning of the file => I could create an option for this. then the name docx2gmf would be more true (as right now we create a jekyll post really)
- (done) automatically convert links into reference style form i.e. from `[text](URL)` into `[text][label] + [label]: URL` (at the end of the post). leads to more readable markup.
- can I move the cleanup steps that are regexps into pandoc itself? (this would assume that pandoc is making mistakes in the docx to gfm conversation)

[gDoc]: https://docs.google.com/document/d/1oKGYVORih0GNC1CZHKv0d2IirCtcgMu0O1sifTfH5zo/edit
