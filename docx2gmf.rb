#!/usr/bin/ruby

require "pp"

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
  content = content.gsub /<span class="underline">(.*?)<\/span>/m,'\1'

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

def move_links_to_the_end(content)
  # matcher = content.scan(/[^!]\[(?<text>.*?)\]\((?<url>.*?)\)/)
  # TODO using named groups below would be more descriptive. Need to figure out how.

  link_dictionary = {}

  content.gsub!(/([^!])\[(.*?)\]\((.*?)\)/) do |match|
    cleaned_link_placeholder = clean_link_placeholder($2)
    if not link_dictionary.has_key?($3)
      link_dictionary[$3] = cleaned_link_placeholder
    end
    "#{$1}[#{$2}][#{link_dictionary[$3]}]"
  end

  # add link references to the end of the content
  content += "\n"
  link_dictionary.each_pair do |url, label|
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
content = move_links_to_the_end(content)
content = add_frontmatter(content)

puts content
