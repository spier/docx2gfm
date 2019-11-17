
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "docx2gfm/version"

Gem::Specification.new do |spec|
  spec.name          = "docx2gfm"
  spec.version       = Docx2gfm::VERSION
  spec.authors       = ["Sebastian Spier"]
  spec.email         = ["github@spier.hu"]

  spec.summary       = "Convert a docx file, to github-flavored-markdown"
  spec.description   = "Convert a docx file, to github-flavored-markdown. thin wrapper around pandoc."
  spec.homepage      = "https://github.com/spier/docx2gfm"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  spec.executables << "docx2gfm"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
