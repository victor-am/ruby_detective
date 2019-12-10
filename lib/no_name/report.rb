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
        file = FileParser.new(file_path, project_path)

        if file.parse
          @files << file
          @classes += file.analysis.classes
        end
      end

      # Move this out of here
      classes.each do |klass|
        constants = klass.constants_referenced.reject { |c| c == klass.name }
        dependencies = constants.map do |constant|
          classes.find { |c| c.name == constant }
        end.flatten.compact

        klass.register_dependencies(dependencies)
      end

      @classes = classes.group_by(&:full_name).map do |_full_name, group|
        if group.size == 1
          group
        else
          group.first.merge_information(group[1..-1])
          [group.first]
        end
      end.flatten

      file_path = 'ruby_detective.html'
      File.delete(file_path) if File.exist?(file_path)
      File.open(file_path, 'w') do |file|
        file << GraphBuilder.new(classes).build
      end
    end
  end
end
