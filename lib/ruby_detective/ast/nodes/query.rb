module RubyDetective
  module AST
    module Nodes
      class Query
        attr_reader :node

        def initialize(node)
          @node = node
        end

        # TODO: ignore constant definitions, only return constant references
        def constant_references(where: {})
          constants = deep_search(node, [:constant_reference_node?])

          case
          when where.key?(:namespace)
            constants.select { |c| c.namespace.include?(where[:namespace].to_sym) }
          else
            constants
          end
        end

        # TODO: ignore constant definitions, only return constant references
        # This finds all constants, ignoring the nested ones.
        # For example:
        # The "Foo::Bar" code contain two constants, but this method will only bring
        # up one (the Bar one), with access to it's full path.
        def top_level_constant_references(where: {})
          constants = deep_search(node, [:constant_reference_node?, :top_level_constant?])

          case
          when where.key?(:namespace)
            constants.select { |c| c.namespace.include?(where[:namespace].to_sym) }
          else
            constants
          end
        end

        def class_declarations
          deep_search(node, [:class_declaration_node?])
        end

        private

        def deep_search(node, validation_methods = [], acc: [])
          return if node.value_node?

          validation_result = validation_methods.map do |validation_method|
            node.respond_to?(validation_method) && node.public_send(validation_method)
          end

          # Only appends the node to the results if all validations passed
          acc << node if validation_result.all?

          node.children.each { |child| send(__method__, child, validation_methods, acc: acc) }
          acc.uniq
        end
      end
    end
  end
end
