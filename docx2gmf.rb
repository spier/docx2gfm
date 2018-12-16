#!/usr/bin/ruby

require "pp"
require "commonmarker"

if ARGV.length < 1
  puts "Too few arguments."
  puts "Provide path to .docx file to be converted to .md (markdown)"
  puts "Example call:"
  puts "ruby md-convert.rb my_post.docx"
  exit
end

# this removes all sorts of strange stuff that pandoc generates when
# converting a .docx exported from Google Docs into GFM
def cleanup_content(content)
  # remove escaping in front of exclamation marks
  content = content.gsub /\\!/, '!'

  # remove underlining of anchors. Anchors are styled by the markdown renderer, so no need to add any explicit formatting here pandoc!
  # example: [<span class="underline">In mattis lectus</span>](https://spier.hu) => [In mattis lectus](https://spier.hu)
  content = content.gsub /\[<span class="underline">(.*?)<\/span>\]/m,'[\1]'

  # convert underlining of regular text (not anchors) into markdown syntax
  # example: <span class="underline">Cras ac lectus quis</span> => _Cras ac lectus quis_
  # Underlining text is not possible??? ok, so I could spit out a warning here, as the author used a formatting feature that our blog does not support

  # fix unordered lists
  content = content.gsub(/^(\s*)- > /, '\1- ')
  content = content.gsub(/^(\s*)> /, '\1  ')

  # fix ordered lists
  content = content.gsub(/^(\d+\.)  > /, '\1  ')

  # remove unnecessary line breaks
  content = content.gsub /(\S)\n *(\S)/m, '\1 \2'

  # remove `<!-- end list -->`
  content = content.gsub(/<!-- end list -->/,'')

  return content
end

def add_frontmatter(content)
  front_matter = open("./assets/front-matter.md").readlines().join()
  content = front_matter + "\n" + content
end

def clean_link_placeholder(text)
  text.downcase.gsub(/\s/,'-')
end

def move_links_to_the_end_regex(content)
  # TODO exclude links to images
  # matcher = content.scan(/\[(.*?)\]\((.*?)\)/)
  matcher = content.scan(/[^!]\[(?<text>.*?)\]\((?<url>.*?)\)/)
  # TODO right now the named groups from the regexp are not shown when I use .scan(). why?

  link_dictionary = {}

  matcher.each do |m|
    cleaned_link_placeholder = clean_link_placeholder(m[0])

    if not link_dictionary.has_key?(cleaned_link_placeholder)
      link_dictionary[cleaned_link_placeholder] = m[1]
    else
      puts "Found duplicate link placeholder. I am not smart enough yet. Skipping link cleanup."
      return content
    end

    # puts "text '#{m[0]}' => #{m[1]}"
  end

  pp link_dictionary

  # replace all URLs in a link with the link_placeholder
  # content.gsub(/[^!]\[(?<text>.*?)\]\((?<url>.*?)\)/)

  # add all link placeholders at the end of the blog posts


  # TODO idea:
  # maybe rather use a proper markdown parser to find and replace the links?
  # https://github.com/gjtorikian/commonmarker

  # pp matcher
end

def convert_to_reference_style_links(content)
  # parse the files specified on the command line
  doc = CommonMarker.render_doc(content)

  dictionary = {}

  # Walk tree and print out URLs for links
  doc.walk do |node|
    if node.type == :link
      # printf("text =  %s, URL = %s\n", node.first_child().string_content, node.url)
      unless (dictionary.has_key?(node.url))
        dictionary[node.url] = clean_link_placeholder(node.first_child().string_content)
      end

      node.first_child.string_content = "[#{node.first_child.string_content}][#{dictionary[node.url]}]"
      node.insert_before(node.first_child)
      node.delete
    end
  end

  content = doc.to_commonmark

  # Cleaning up the messy doc.to_commonmark creates references like this:
  # \[text\]\[reference\] => [text][reference]
  # TODO is it really true that backslash (\) does not appear in the text. dangerous move!!
  content = content.gsub(/\\(\[|\])/,"\\1")

  # add references to the end of the content
  content += "\n"
  dictionary.each_pair do |url, label|
      content += "[#{label}]: #{url}\n"
  end

  return content
end

# convert docx to initial markdown
def docx_2_markdown(docx_filename)
  # TODO check out pandoc options that might be useful e.g. --extract-media='/images/own/'
  `pandoc #{docx_filename} -f docx -t gfm`
end


# ------------------
# MAIN
# ------------------

docx_filename = ARGV[0]

content = docx_2_markdown(docx_filename)
content = cleanup_content(content)
content = convert_to_reference_style_links(content)
content = add_frontmatter(content)

puts content
