require 'docx2gfm/version'
require 'docx2gfm/docx_gfm_converter'

require 'pp'
require 'optparse'

module Docx2gfm

  class Runner

    def self.run

      # set default values for options
      options = {}
      options[:jekyll] = true
      options[:ref_style_links] = true

      # specify available options for the CLI
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: docx2gfm [options]'

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
        opts.on('-v', '--version', 'Show version of docx2gfm') do
          puts Docx2gfm::VERSION
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

      # pass on options to the Docx2Gfm Converter, and run the conversion
      doc = DocxGfmConverter.new(options)
      doc.process_markdown
      puts doc

    end #run

  end #class

end # module
