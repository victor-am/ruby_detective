module RubyDetective
  module AST
    module Nodes
      class ConstantReferenceNode < GenericNode
        CONSTANT_NAME_INDEX = 1
        def constant_name
          children[CONSTANT_NAME_INDEX].value
        end

        def full_constant_reference_name
          namespace + [constant_name]
        end

        def type
          :const
        end
      end
    end
  end
end
