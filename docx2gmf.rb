#!/usr/bin/ruby

require 'pp'
require 'optparse'

class Docx2Gmf
  attr_accessor :options, :content

  def initialize(options)
    @options = options
  end

  # perform all conversation and cleanup steps
  def process()
    docx_2_markdown(@options[:file])
    cleanup_content()
    move_links_to_the_end() if @options[:ref_style_links]
    add_frontmatter() if @options[:jekyll]
  end

  # output this document (i.e. the markdown content)
  def to_s
    @content
  end

  # convert docx to initial markdown
  def docx_2_markdown(file)
    # TODO before reading the file, I could check if the file exists
    # TODO check out pandoc options that might be useful e.g. --extract-media='/images/own/'
    @content = `pandoc #{file} -f docx -t gfm`
  end

  # this removes all sorts of strange stuff that pandoc generates when
  # converting a .docx exported from Google Docs into GFM
  def cleanup_content()
    # remove escaping in front of exclamation marks
    @content = @content.gsub /\\!/, '!'

    # remove underlining of anchors. Anchors are styled by the markdown renderer, so no need to add any explicit formatting here pandoc!
    # example: [<span class="underline">In mattis lectus</span>](https://spier.hu) => [In mattis lectus](https://spier.hu)
    @content = @content.gsub /\[<span class="underline">(.*?)<\/span>\]/m,'[\1]'

    # convert underlining of regular text (not anchors) into markdown syntax
    # example: <span class="underline">Cras ac lectus quis</span> => _Cras ac lectus quis_
    # Underlining text is not possible??? ok, so I could spit out a warning here, as the author used a formatting feature that our blog does not support
    @content = @content.gsub /<span class="underline">(.*?)<\/span>/m,'\1'

    # fix unordered lists
    @content = @content.gsub(/^(\s*)- > /, '\1- ')
    @content = @content.gsub(/^(\s*)> /, '\1  ')

    # fix ordered lists
    @content = @content.gsub(/^(\d+\.)  > /, '\1  ')

    # remove unnecessary line breaks
    @content = @content.gsub /(\S)\n *(\S)/m, '\1 \2'

    # remove `<!-- end list -->`
    @content = @content.gsub(/<!-- end list -->/,'')
  end

  def add_frontmatter()
    front_matter = open("./assets/front-matter.md").readlines().join()
    @content = front_matter + "\n" + @content
  end

  def clean_link_placeholder(text)
    text.downcase.gsub(/\s/,'-')
  end

  def move_links_to_the_end()
    # matcher = content.scan(/[^!]\[(?<text>.*?)\]\((?<url>.*?)\)/)
    # TODO using named groups below would be more descriptive. Need to figure out how.
    link_dictionary = {}

    @content.gsub!(/([^!])\[(.*?)\]\((.*?)\)/) do |match|
      cleaned_link_placeholder = clean_link_placeholder($2)
      if not link_dictionary.has_key?($3)
        link_dictionary[$3] = cleaned_link_placeholder
      end
      "#{$1}[#{$2}][#{link_dictionary[$3]}]"
    end

    # add link references to the end of the content
    @content += "\n"
    link_dictionary.each_pair do |url, label|
        @content += "[#{label}]: #{url}\n"
    end
  end

end #class

# ------------------
# MAIN
# ------------------

options = {}
options[:jekyll] = true
options[:ref_style_links] = true

parser = OptionParser.new do |opts|
  opts.banner = "Usage: docx2gmf.rb [options]"

  opts.on('-f', '--file FILE', '(required) The .docx file to convert to markdown') do |v|
    options[:file] = v
  end
  opts.on('-j', '--[no-]jekyll', '(optional) Prefix the markdown output with a jekyll frontmatter. Default: --jekyll') do |v|
    options[:jekyll] = v
  end
  opts.on('-r', '--[no-]ref-style-links', '(optional) Create reference style links at the end of the markdown. Default: --ref-style-links') do |v|
    options[:ref_style_links] = v
  end
  opts.on('-h', '--help', 'Display this help screen') do
    puts opts
    exit
  end
end

# most useful way of creating a required parameter with OptionParser
# https://stackoverflow.com/questions/1541294/how-do-you-specify-a-required-switch-not-argument-with-ruby-optionparser/1542658#1542658
begin
  parser.parse!
  mandatory = [:file]
  missing = mandatory.select{ |param| options[param].nil? }
  raise OptionParser::MissingArgument, missing.join(', ') unless missing.empty?
rescue OptionParser::ParseError => e
  puts e
  puts parser
  exit
end


doc = Docx2Gmf.new(options)
doc.process
puts doc


# TODO for this feature

# - check if there is a way to provided the file via a ARGV param, rather than an option (why?)
# - describe in the console help which option is the default (are there better ways to do this?)

# Other todo:
# - check if the file provided is indeed a .docx file (righ tnow it produces an empty output for everything)
# - move class into separate file in ./lib folder (check what the default for gems is)
