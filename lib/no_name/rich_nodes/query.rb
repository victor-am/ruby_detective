module NoName
  module RichNodes
    class Query
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def constant_references(where: {})
        constants = search_constant_references(node)

        if where[:namespace]
          constants.select { |c| c.namespace.include?(where[:namespace]) }
        else
          constants
        end
      end

      def class_declarations
        search_class_declarations(node)
      end

      private

      def search_class_declarations(node, acc = [])
        return if node.value_node?

        node.children.each do |child|
          acc << child if child.class_declaration_node?
          search_class_declarations(child, acc)
        end

        acc.uniq
      end

      def search_constant_references(node, acc = [])
        return if node.value_node?

        node.children.each do |child|
          acc << child if child.constant_reference_node?
          search_constant_references(child, acc)
        end

        acc.uniq
      end
    end
  end
end
