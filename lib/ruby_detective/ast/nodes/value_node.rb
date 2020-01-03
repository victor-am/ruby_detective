module RubyDetective
  module AST
    module Nodes
      class ValueNode < GenericNode
        attr_reader :value

        def initialize(value, *args)
          super(value, *args)
          @value = value
        end

        def type
          :value
        end

        def first_line
          parent_node.first_line
        end

        def last_line
          parent_node.last_line
        end

        def raw_children
          []
        end
      end
    end
  end
end
