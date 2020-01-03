module RubyDetective
  module AST
    module Nodes
      class AbsolutePathSignNode < GenericNode
        def type
          :absolute_path_sign
        end
      end
    end
  end
end
