module NoName
  module RichNodes
    class Query
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def constant_references(where: {})
        constants = deep_search(:constant_reference_node?, node)
        return constants unless where[:namespace]

        constants.select { |c| c.namespace.include?(where[:namespace]) }
      end

      def class_declarations
        deep_search(:class_declaration_node?, node)
      end

      private

      def deep_search(validation_method, node, acc = [])
        return if node.value_node?

        acc << node if node.public_send(validation_method)
        node.children.each { |child| send(__method__, validation_method, child, acc) }

        acc.uniq
      end
    end
  end
end
