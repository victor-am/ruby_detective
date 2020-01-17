require "json"

module RubyDetective
  class JSONBuilder
    attr_reader :classes

    def initialize
      data_store = SourceRepresentation::DataStore.instance
      @classes = data_store.classes
    end

    def self.build(*args)
      new(*args).build
    end

    def build
      classes_data_as_json = classes.map do |c|
        {
          name: c.name,
          full_name: c.path_as_text,
          namespace: c.namespace_as_text,
          lines_of_code: c.lines_of_code,
          dependencies: c.dependencies.map(&:path_as_text),
          dependents: c.dependents.map(&:path_as_text),
          file_path: c.file_path
        }
      end.to_json
    end
  end
end
