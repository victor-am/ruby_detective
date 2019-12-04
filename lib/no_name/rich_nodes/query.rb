module NoName
  module RichNodes
    class Query
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def constant_references(where: {})
        constants = search_constant_references(node)
        return constants unless where[:namespace]

        constants.select { |c| c.namespace.include?(where[:namespace]) }
      end

      def class_declarations
        search_class_declarations(node)
      end

      private

      def search_class_declarations(node, acc = [])
        return if node.value_node?

        acc << node if node.class_declaration_node?
        node.children.each { |child| search_class_declarations(child, acc) }

        acc.uniq
      end

      def search_constant_references(node, acc = [])
        return if node.value_node?

        acc << node if node.constant_reference_node?
        node.children.each { |child| search_constant_references(child, acc) }

        acc.uniq
      end
    end
  end
end
