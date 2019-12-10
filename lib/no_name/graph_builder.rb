require 'json'
require 'erb'

module NoName
  class GraphBuilder
    attr_reader :classes

    def initialize(classes)
      @classes = classes
      @erb_template = File.read(File.join(File.dirname(__FILE__), "../../assets/template.html.erb")
)
    end

    def build
      classes_data_as_json = classes.map do |c|
        {
          name: c.name,
          full_name: c.full_name,
          namespace: c.namespace[0..-2].join('::'),
          lines_of_code: c.lines_of_code,
          dependencies: c.dependencies.map(&:full_name),
          file_path: c.file_path
        }
      end.to_json

      ERB.new(@erb_template).result(binding)
    end
  end
end
