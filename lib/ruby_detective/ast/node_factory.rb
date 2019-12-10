module RubyDetective
  module AST
    class NodeFactory
      attr_reader :node, :file_path, :parent_node

      def initialize(node, file_path:, parent_node: nil)
        @node = node
        @file_path = file_path
        @parent_node = parent_node
      end

      def self.build(*args)
        new(*args).build
      end

      def build
        node_class.new(node, file_path: file_path, parent_node: parent_node)
      end

      private

      def node_class
        return Nodes::ValueNode if not_an_ast_node?

        case node.type
        when :class
          Nodes::ClassDeclarationNode
        when :module
          Nodes::ModuleDeclarationNode
        when :const
          Nodes::ConstantReferenceNode
        else
          Nodes::GenericNode
        end
      end

      def not_an_ast_node?
        !node.is_a?(Parser::AST::Node)
      end
    end
  end
end
