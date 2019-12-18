begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :test => :spec
rescue LoadError
  # no rspec available
end
