require 'parser/current'

module RubyDetective
  class Report
    attr_reader :project_path, :classes, :modules

    def initialize(project_path)
      @project_path = project_path
    end

    def run
      puts "Processing files..."

      classes = []
      Dir.glob("#{project_path}/**/*.rb") do |file_path|
        file = FileParser.new(file_path, project_path)
        classes += file.analysis.classes if file.parse
      end

      puts "Finding dependencies..."
      classes = DependencySearch.new(classes).run

      puts "Generating output file..."
      UIGenerator.new(classes).generate

      puts "Done!"
    end
  end
end
