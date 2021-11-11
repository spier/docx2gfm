class DocxGfmConverter
  attr_accessor :options, :content

  def initialize(options)
    @options = options
  end

  # perform all conversation and cleanup steps
  # def process_gfm()
  #   docx_2_gfm(@options[:file])
  #   cleanup_content_gfm()
  #   create_ref_style_links() if @options[:ref_style_links]
  #   add_frontmatter() if @options[:jekyll]
  # end

  def process_markdown()
    docx_2_markdown(@options[:file])
    cleanup_content_markdown()
    create_ref_style_links() if @options[:ref_style_links]
    add_frontmatter() if @options[:jekyll]
  end

  # output this document (i.e. the markdown content)
  def to_s
    @content
  end

  # convert docx to initial markdown
  # def docx_2_gfm(file)
  #   # TODO before reading the file, I could check if the file exists
  #   # TODO check out pandoc options that might be useful e.g. --extract-media='/images/own/'
  #   @content = `pandoc #{file} -f docx -t gfm --wrap=none`
  # end

  def docx_2_markdown(file)
    # TODO before reading the file, I could check if the file exists
    # TODO check out pandoc options that might be useful e.g. --extract-media='/images/own/'
    @content = `pandoc '#{file}' --wrap=none --atx-headers -f docx -t markdown-bracketed_spans-link_attributes-smart-simple_tables -s`
  end

  # this removes all sorts of strange stuff that pandoc generates when
  # converting a .docx exported from Google Docs into GFM
  def cleanup_content_gfm()
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

    # remove `<!-- end list -->`
    # See http://pandoc.org/MANUAL.html => "Ending a list"
    @content = @content.gsub(/<!-- end list -->/,'')
  end

  def cleanup_content_markdown()
    # remove underlining from links
    @content = @content.gsub /\[<span class="underline">(.*?)<\/span>\]/m,'[\1]'

    # remove underlining from all other text (and print a warning)
    @content = @content.gsub(/<span class="underline">(.*?)<\/span>/m) do |match|
      STDERR.puts "Underline is not supported in markdown. Removing underlining from '#{$1}'."
      $1
    end

    # fix lists - remove unneccesary spacing before list items
    # 1.  Numbered lists are great
    # -   And even more bullets
    @content = @content.gsub(/^(\s*)(-|\d+\.)\s+(\S)/, '\1\2 \3')

    # fix spacing in front of reference links
    @content = @content.gsub(/^ +(\[.+?\]:)/, '\1')
  end

  def add_frontmatter()
    asset_file = File.join(File.dirname(__FILE__), '/assets/front-matter.md')
    front_matter = open(asset_file).readlines().join()
    @content = front_matter + "\n" + @content
  end

  def clean_link_placeholder(text)
    text.downcase.gsub(/\s/,'-')
  end

  def create_ref_style_links()
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
