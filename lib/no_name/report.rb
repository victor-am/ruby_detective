require 'parser/current'

module NoName
  class Report
    attr_reader :project_path, :classes, :modules

    def initialize(project_path)
      @project_path = project_path
      @files = []
      @classes = []
    end

    def run
      puts "Starting!!"

      Dir.glob("#{project_path}/**/*.rb") do |file_path|
        file = FileParser.new(file_path)
        file.parse
        @files << file
        @classes += file.analysis.classes
      end

      # Move this out of here
      classes.each do |klass|
        constants = klass.constants_referenced.reject { |c| c == klass.name }
        dependencies = constants.map do |constant|
          classes.find { |c| c.name == constant }
        end.compact

        klass.register_dependencies(dependencies)
      end

      classes.each do |c|
        puts "---------------------------------------"
        puts c.name.to_s + ' < ' + c.inheritance_class_name.to_s
        puts " "
        puts 'File path: ' + c.file_path
        puts 'Namespace: ' + c.namespace.to_s
        puts " "
        puts "-[ Constants referenced ]-"
        c.constants_referenced.each { |c| puts c }
        puts "-[ Dependencies detected ]-"
        c.dependencies.each { |c| puts c.full_name }
      end
    end
  end
end
