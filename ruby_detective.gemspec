Gem::Specification.new do |s|
  s.name        = "ruby_detective"
  s.version     = "0.0.3"
  s.date        = "2020-01-20"
  s.summary     = "Allows to investigate your ruby project dependency network"
  s.description = "Ruby Detective is a gem that parses your code, finds it's dependencies and outputs a interactive .html file that you can use to explore the dependency network of the code."
  s.authors     = ["Victor Marques"]
  s.email       = "victor.atmorning@gmail.com"
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|docs|ui|coverage|)/}) }
  s.homepage    = "https://github.com/victor-am/ruby_detective"
  s.license       = "MIT"
  s.bindir        = "bin"
  s.executables << "ruby_detective"
  s.require_paths = ["lib"]

  s.add_dependency "parser", "~> 2.6.5"

  s.add_development_dependency "rake", "~> 13.0.1"
  s.add_development_dependency "rspec", "~> 3.9.0"
  s.add_development_dependency "simplecov", "~> 0.17.1"
  s.add_development_dependency "pry"
end
