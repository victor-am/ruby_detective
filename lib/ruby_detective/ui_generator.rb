require 'json'
require 'erb'

module RubyDetective
  class UIGenerator
    attr_reader :classes

    def initialize(classes)
      @classes = classes
    end

    def generate
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

      template_path = File.join(File.dirname(__FILE__), "../../views/template.html.erb")
      erb_template = File.read(template_path)
      ui_source_code = ERB.new(erb_template).result(binding)

      output_file_path = 'ruby_detective.html'
      File.delete(output_file_path) if File.exist?(output_file_path)
      File.open(output_file_path, 'w') { |file| file << ui_source_code }
    end
  end
end
