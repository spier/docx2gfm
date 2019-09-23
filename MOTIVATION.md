# Motivation

Why use docx2gfm, instead of using pandoc straight up?

docx2gfm is a wrapper around [pandoc][pandoc], which does the heavy-lifting of the docx to markdown conversation. So why not use pandoc straight up you may ask?

The best pandoc configuration that I could find so far is this:

```
pandoc examples/sample.docx --wrap=none --atx-headers --reference-links -f docx -t markdown-bracketed_spans-link_attributes-smart-simple_tables -s
```

It produces the markdown output as shown in [examples/sample-pure-pandoc.md](./examples/sample-pure-pandoc.md).

While this is pretty good already, this markdown has the following shortcomings:

* lists have superfluous spaces before each list item
* HTML formatting for underlines is created e.g. `<span class="underline">In mattis lectus</span>` => one could use something similar to `sed -e 's/<[^>]*>//g'` to get rid of the HTML. However this will also remove the HTML placeholders for the images, which are good to keep.
* less pretty reference-links at the end of the file

[pandoc]: https://pandoc.org/installing.html
