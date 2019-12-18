module RubyDetective
  module AST
    class Query
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def all(where: {})
        constants = deep_search(node)

        case where
        when -> (w) { w.key?(:type) }
          constants.select { |c| c.type == where[:type] }
        else
          constants
        end
      end

      def constant_references(where: {})
        constants = deep_search(node, :constant_reference_node?)

        case where
        when -> (w) { w.key?(:namespace) }
          constants.select { |c| c.namespace.include?(where[:namespace].to_sym) }
        else
          constants
        end
      end

      def class_declarations
        deep_search(node, :class_declaration_node?)
      end

      private

      def deep_search(node, validation_method = nil, acc: [])
        return if node.value_node?

        acc << node if !validation_method || node.public_send(validation_method)
        node.children.each { |child| send(__method__, child, validation_method, acc: acc) }

        acc.uniq
      end
    end
  end
end
