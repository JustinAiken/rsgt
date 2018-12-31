lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rsgt/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "rsgt"
  s.version     = RSGuitarTech::VERSION
  s.authors     = ["Justin Aiken"]
  s.email       = ["60tonangel@gmail.com"]
  s.license     = "MIT"
  s.homepage    = "https://github.com/JustinAiken/rsgt"
  s.summary     = %q{Rocksmith}
  s.description = %q{Rocksmith}

  s.rubyforge_project = "rsgt"

  s.files           = `git ls-files`.split("\n")
  s.test_files      = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths   = ["lib"]
  s.bindir          = "bin"
  s.executables     = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  s.add_dependency "bindata",       "~> 2.4"
  s.add_dependency "trollop",       "~> 2.1"
  s.add_dependency "rainbow",       "~> 2.2"
  s.add_dependency "activesupport", ">= 3.0"

  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "pry"
end
