Gem::Specification.new do |s|
  s.name        = "ruby_detective"
  s.version     = "0.0.1"
  s.date        = "2019-01-30"
  s.summary     = "Allows to investigate your ruby project dependency network"
  s.description = "Ruby Detective is a gem that parses your code, finds it's dependencies and outputs a interactive .html file that you can use to explore the dependency network of the code."
  s.authors     = ["Victor Marques"]
  s.email       = "victor.atmorning@gmail.com"
  s.files       = ["lib/ruby_detective.rb"]
  s.homepage    = "https://github.com/victor-am/ruby_detective"
  s.license       = "MIT"
  s.bindir        = "bin"
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "parser", "~> 2.6.5"

  s.add_development_dependency "rake", "~> 13.0.1"
  s.add_development_dependency "rspec", "~> 3.9.0"
  s.add_development_dependency "simplecov", "~> 0.17.1"
  s.add_development_dependency "pry"
end
