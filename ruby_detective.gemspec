Gem::Specification.new do |s|
  s.name        = "ruby_detective"
  s.version     = "0.0.0"
  s.date        = "2019-01-30"
  s.summary     = ""
  s.description = ""
  s.authors     = ["Victor Marques"]
  s.email       = ""
  s.files       = ["lib/ruby_detective.rb"]
  s.homepage    = ""
  s.license       = "MIT"
  s.bindir        = "bin"
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "parser", "~> 2.6.5"
  s.add_development_dependency "rake", "~> 13.0.1"
  s.add_development_dependency "rspec", "~> 3.9.0"
  s.add_development_dependency "simplecov", "~> 0.17.1"
end
