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

      classes[0..25].each do |c|
        puts "---------------------------------------"
        puts c.name.to_s + ' < ' + c.inherited_class.to_s
        puts " "
        puts 'File path: ' + c.file_path
        puts 'Namespace: ' + c.namespace.to_s
        puts " "
        puts "-[ Dependencies ]-"
        c.constants_referenced.each { |c| puts c }
      end
    end
  end
end
