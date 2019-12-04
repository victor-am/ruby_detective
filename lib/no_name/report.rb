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

      Dir.glob("#{project_path}/app/**/*.rb") do |file_path|
        file = FileParser.new(file_path)
        file.parse
        @files << file
      end

      @classes = @files.map(&:class_definitions).flatten

      classes[0..25].each do |c|
        puts "[ Class ] ----------------"
        puts c.name.to_s + ' < ' + c.inherited_class.to_s
        puts 'File path: ' + c.file_path
        puts 'Namespace: ' + c.namespace.to_s
      end
    end
  end
end
