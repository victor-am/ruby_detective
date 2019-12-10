module RubyDetective
  class FileParser
    attr_reader :path, :analysis

    def initialize(file_path, project_path)
      @path = file_path
      @project_path = project_path
    end

    def parse
      code = File.read(path)
      @analysis = AST::Analyzer.new(code, clean_path)
      analysis.run
      true
    end

    private
    attr_reader :project_path

    def clean_path
      path.sub(project_path, "")
    end
  end
end
