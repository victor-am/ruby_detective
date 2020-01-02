module RubyDetective
  class FileParser
    attr_reader :path, :analysis

    def initialize(file_path, project_path, data_store:)
      @path = file_path
      @project_path = project_path
      @data_store = data_store
    end

    def parse
      code = File.read(path)

      raw_ast = Parser::CurrentRuby.parse(code)
      return false if raw_ast.nil? # Empty file scenario

      rich_ast = AST::NodeFactory.build(raw_ast, file_path: clean_path)
      rich_ast.process_all_children!

      AST::Interpreter.interpret_node_and_populate_store(
        rich_ast,
        clean_path,
        data_store: data_store
      )
    end

    private
    attr_reader :project_path, :data_store

    def clean_path
      path.sub(project_path, "")
    end
  end
end
