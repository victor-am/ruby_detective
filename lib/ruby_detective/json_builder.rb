require "json"

module RubyDetective
  class JSONBuilder
    attr_reader :classes

    def initialize(data_store)
      @classes = data_store.classes
    end

    def self.build(*args)
      new(*args).build
    end

    def build
      classes_data_as_json = classes.map do |c|
        {
          name: c.name,
          full_name: c.full_name,
          namespace: c.namespace[0..-2].join("::"),
          lines_of_code: c.lines_of_code,
          dependencies: c.dependencies.map(&:full_name),
          dependents: c.dependents.map(&:full_name),
          file_path: c.file_path
        }
      end.to_json
    end
  end
end
