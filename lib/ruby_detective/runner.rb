require "parser/current"

module RubyDetective
  class Runner
    attr_reader :project_path, :classes, :modules

    def initialize(project_path)
      @project_path = project_path
    end

    def run
      data_store = SourceRepresentation::DataStore.new

      puts "Processing files..."
      Dir.glob("#{project_path}/**/*.rb") do |file_path|
        AST::FileParser.new(file_path, project_path, data_store: data_store).parse
      end

      puts "Finding dependencies..."
      SourceRepresentation::DependencyResolver.resolve_and_populate_store(data_store)

      if ENV["ENV"] == "development"
        puts "Generating output .json file..."
        json = JSONBuilder.build(data_store)

        output_file_path = "ui/src/data.json"
        File.delete(output_file_path) if File.exist?(output_file_path)
        File.open(output_file_path, "w") { |file| file << json }
      else
        puts "Generating output HTML file..."
        UIGenerator.new(data_store).generate
      end

      puts "Done!"
    end
  end
end
