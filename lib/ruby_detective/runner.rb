require "parser/current"

module RubyDetective
  class Runner
    attr_reader :project_path, :classes, :modules

    def initialize(project_path)
      if [nil, "", " "].include? project_path
        @project_path = "."
      else
        @project_path = project_path
      end
    end

    def run
      puts "Processing files..."
      Dir.glob("#{project_path}/**/*.rb") do |file_path|
        AST::FileParser.new(file_path, project_path).parse
      end

      puts "Finding dependencies..."
      SourceRepresentation::DataStore.instance.resolve_dependencies

      if ENV["ENV"] == "development"
        puts "Generating output .json file..."
        json = ::RubyDetective::JSONBuilder.build

        output_file_path = "ui/src/data.json"
        File.delete(output_file_path) if File.exist?(output_file_path)
        File.open(output_file_path, "w") { |file| file << json }
      else
        puts "Generating output HTML file..."
        UIGenerator.generate
      end

      puts "Done!"
    end
  end
end
