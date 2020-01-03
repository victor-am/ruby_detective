module RubyDetective
  module AST
    module Nodes
      class RootSignNode < GenericNode
        def type
          :root_sign
        end
      end
    end
  end
end
