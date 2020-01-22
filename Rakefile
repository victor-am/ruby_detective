begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :test => :spec
rescue LoadError
  # no rspec available
end

desc "Rebuilds the template file in views/template.html.erb and commits it"
task :build_ui do
  system <<~SHELL
    cd ui &&
    yarn build &&
    cd - &&
    git add . &&
    git commit -m 'Build the UI template'
  SHELL
end

VERSION_LINE_REGEX = /s\.version.*$/
GEMSPEC_FILE = "ruby_detective.gemspec"

desc "Bumps the gem version and commits it with an annotated tag"
task :bump_version, [:new_version] do |_t, args|
  new_version = args[:new_version]

  gemspec_file = File.read(GEMSPEC_FILE)
  version_line = gemspec_file.scan(VERSION_LINE_REGEX).first

  new_version_line = version_line.sub(/\d+\.\d+\.\d+/, new_version)
  new_gemspec_file = gemspec_file.sub(VERSION_LINE_REGEX, new_version_line)
  File.open(GEMSPEC_FILE, "w") {|file| file.puts new_gemspec_file }

  system <<~SHELL
    git add . &&
    git commit -m 'Bump version to #{new_version}' &&
    git tag v#{new_version}
  SHELL
end

desc "Builds the gem"
task :build_gem do
  system "gem build ruby_detective.gemspec"
end
