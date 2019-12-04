module NoName
  module RichNodes
    class Factory
      attr_reader :node, :file_path, :namespace

      def initialize(node, file_path:, namespace: [])
        @node = node
        @file_path = file_path
        @namespace = namespace
      end

      def self.build(*args)
        new(*args).build
      end

      def build
        node_class.new(node, file_path: file_path, namespace: namespace)
      end

      private

      def node_class
        return ValueNode if not_an_ast_node?

        case node.type
        when :class
          ClassDeclarationNode
        when :module
          ModuleDeclarationNode
        when :const
          ConstantReferenceNode
        else
          GenericNode
        end
      end

      def not_an_ast_node?
        !node.is_a?(Parser::AST::Node)
      end
    end
  end
end
