require "parser/current"

module RubyDetective
  class Runner
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

      if ENV["ENV"] == "development"
        puts "Generating output .json file..."
        json = JSONBuilder.build(classes)

        output_file_path = "ui/src/data.json"
        File.delete(output_file_path) if File.exist?(output_file_path)
        File.open(output_file_path, "w") { |file| file << json }
      else
        puts "Generating output HTML file..."
        UIGenerator.new(classes).generate
      end

      puts "Done!"
    end
  end
end
