module NoName
  module RichNodes
    class GenericNode
      attr_reader :ast_node, :namespace, :children, :file_path

      def initialize(ast_node, namespace: [], file_path:)
        @ast_node = ast_node
        @namespace = namespace
        @file_path = file_path
        @children = []
      end

      def process_all_children!
        raw_children.each do |raw_child_node|
          child_node = RichNodes::Factory.build(raw_child_node, file_path: file_path)
          child_node.process_all_children!
          @children << child_node
        end
      end

      def class_definitions
        children.map(&:class_definitions).flatten.uniq
      end

      def module_definitions
        children.map(&:module_definitions).flatten.uniq
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

      private

      def type
        ast_node.type
      end

      def raw_children
        ast_node.children
      end
    end
  end
end
