module RubyDetective
  module AST
    class NodeFactory
      attr_reader :node, :rich_node, :file_path, :parent_node

      # A dictionary that converts the Parser gem type to our Rich AST type
      NODE_TYPE_DICTIONARY = {
        const: :constant,
        class: :class,
        module: :module,
        cbase: :absolute_path_sign
      }
      # The following types also exist:
      #
      # value - the last node of a branch, can be nil, a string, a symbol, etc...
      # generic - a broader "others" type, for any nodes not mapped out

      def initialize(node, file_path:, parent_node: nil)
        @node = node
        @rich_node = nil
        @file_path = file_path
        @parent_node = parent_node
      end

      def build
        @rich_node = node_class.new(node, file_path: file_path, parent_node: parent_node)
      end

      def process_all_children
        rich_node.raw_children.each do |raw_child_node|
          factory = self.class.new(
            raw_child_node,
            file_path: file_path,
            parent_node: rich_node
          )
          child_node = factory.build

          rich_node.children << child_node
          factory.process_all_children
        end
      end

      private

      def node_class
        case node_type
        when :class
          Nodes::ClassDeclarationNode
        when :module
          Nodes::ModuleDeclarationNode
        when :constant
          Nodes::ConstantReferenceNode
        when :absolute_path_sign
          Nodes::AbsolutePathSignNode
        when :value
          Nodes::ValueNode
        when :generic
          Nodes::GenericNode
        end
      end

      def node_type
        if not_an_ast_node?
          :value
        elsif NODE_TYPE_DICTIONARY.key?(node.type)
          NODE_TYPE_DICTIONARY[node.type]
        else
          :generic
        end
      end

      def not_an_ast_node?
        !node.is_a?(Parser::AST::Node)
      end
    end
  end
end
