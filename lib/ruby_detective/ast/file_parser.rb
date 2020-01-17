module RubyDetective
  module AST
    class FileParser
      attr_reader :path, :project_path, :rich_ast

      def initialize(file_path, project_path)
        @path = file_path
        @project_path = project_path
      end

      def parse
        code = File.read(path)

        raw_ast = Parser::CurrentRuby.parse(code)
        return false if raw_ast.nil? # Empty file scenario

        factory = AST::NodeFactory.new(raw_ast, file_path: clean_path)
        @rich_ast = factory.build
        factory.process_all_children

        AST::Interpreter.interpret_node_and_populate_store(
          rich_ast,
          clean_path
        )
      end

      private

      def clean_path
        path.sub(project_path, "")
      end
    end
  end
end
