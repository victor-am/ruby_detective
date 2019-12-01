Gem::Specification.new do |s|
  s.name        = 'no_name'
  s.version     = '0.0.0'
  s.date        = '2019-01-30'
  s.summary     = ""
  s.description = ""
  s.authors     = ["Victor Marques"]
  s.email       = ''
  s.files       = ['lib/no_name.rb']
  s.homepage    =
    ''
  s.license       = 'MIT'
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'parser', '~> 2.6.5'
end
