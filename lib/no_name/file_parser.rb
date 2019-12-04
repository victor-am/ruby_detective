module NoName
  class FileParser
    attr_reader :path, :rich_ast, :analysis

    def initialize(file_path)
      @path = file_path
    end

    def parse
      @code = File.read(path)
      @raw_ast = Parser::CurrentRuby.parse(@code)
      @rich_ast = RichNodes::Factory.build(raw_ast, file_path: path)

      rich_ast.process_all_children!

      @analysis = RichASTAnalyzer.new(rich_ast)
      analysis.analyze
    end

    private
    attr_reader :raw_ast
  end
end
