require "erb"

module RubyDetective
  class UIGenerator
    attr_reader :data_store

    def initialize(data_store)
      @data_store = data_store
    end

    def generate
      # Variable used inside the template
      classes_data_as_json = JSONBuilder.build(data_store)

      template_path = File.join(File.dirname(__FILE__), "../../views/template.html.erb")
      erb_template = File.read(template_path)
      ui_source_code = ERB.new(erb_template).result(binding)

      output_file_path = 'ruby_detective.html'
      File.delete(output_file_path) if File.exist?(output_file_path)
      File.open(output_file_path, 'w') { |file| file << ui_source_code }
    end
  end
end
