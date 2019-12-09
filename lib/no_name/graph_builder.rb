require 'json'

module NoName
  class GraphBuilder
    attr_reader :classes

    def initialize(classes)
      @classes = classes
    end

    def build
      classes.map do |c|
        {
          name: c.name,
          full_name: c.full_name,
          namespace: c.namespace[0..-2].join('::'),
          lines_of_code: c.lines_of_code,
          dependencies: c.dependencies.map(&:full_name),
          file_path: c.file_path
        }
      end.to_json
    end
  end
end
