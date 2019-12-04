module NoName
  module RichNodes
    class GenericNode
      attr_reader :ast_node, :children, :file_path, :parent_node

      def initialize(ast_node, file_path:, parent_node:)
        @ast_node = ast_node
        @file_path = file_path
        @children = []
        @parent_node = parent_node
      end

      def namespace
        build_namespace(self)
      end

      def declared_namespace
        nil
      end

      def class_declaration_node?
        type == :class
      end

      def module_declaration_node?
        type == :module
      end

      def constant_reference_node?
        type == :const
      end

      def value_node?
        type == :value
      end

      def type
        ast_node.type
      end

      def query_class_declarations(*args)
        RichNodes::Query.new(self).class_declarations(*args)
      end

      def query_constant_references(*args)
        RichNodes::Query.new(self).constant_references(*args)
      end

      # Move this outside
      # Should keep inside the nodes code only stuff that works with a fully
      # built rich AST
      def process_all_children!
        raw_children.each do |raw_child_node|
          child_node = RichNodes::Factory.build(
            raw_child_node,
            file_path: file_path,
            parent_node: self
          )

          child_node.process_all_children!
          @children << child_node
        end
      end

      private

      def raw_children
        ast_node.children
      end

      def build_namespace(node, acc = [])
        return acc.flatten.compact if node.nil?

        acc.prepend(node.declared_namespace)
        build_namespace(node.parent_node, acc)
      end
    end
  end
end
