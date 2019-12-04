module NoName
  module RichNodes
    class Factory
      attr_reader :node, :file_path

      def initialize(node, file_path:)
        @node = node
        @file_path = file_path
      end

      def self.build(*args)
        new(*args).build
      end

      def build
        return ValueNode.new(node, file_path: file_path) if not_an_ast_node?

        case node.type
        when :class
          ClassDeclarationNode.new(node, file_path: file_path)
        when :module
          ModuleDeclarationNode.new(node, file_path: file_path)
        when :const
          ConstantReferenceNode.new(node, file_path: file_path)
        else
          GenericNode.new(node, file_path: file_path)
        end
      end

      private

      def not_an_ast_node?
        !node.is_a?(Parser::AST::Node)
      end
    end
  end
end
