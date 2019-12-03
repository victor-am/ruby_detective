require 'parser/current'

module NoName
  class Report
    attr_reader :project_path, :classes, :modules

    def initialize(project_path)
      @project_path = project_path
      @classes = []
      @modules = []
      @files = []
    end

    def run
      puts "Starting!!"

      Dir.glob("#{project_path}/app/**/*.rb") do |file_path|
        file = FileParser.new(file_path)
        file.parse
        @files << file

        file.class_definitions.each { |class_name| register_class_definition(class_name) }
        file.module_definitions.each { |class_name| register_module_definition(class_name) }
      end

      @files[0..15].each do |f|
        puts "------[ Start ]-------"
        puts "File path: " + f.path
        puts "----------------------"
        puts "Modules: " + f.module_definitions.to_s
        puts "Classes: " + f.class_definitions.to_s
        puts "Inheritances: " + f.inheritance_definitions.to_s
        puts "---[ Dependencies ]---"
        puts f.constants
      end
    end

    private

    def register_class_definition(class_name)
      @classes << class_name
    end

    def register_module_definition(module_name)
      @modules << module_name
    end
  end
end
