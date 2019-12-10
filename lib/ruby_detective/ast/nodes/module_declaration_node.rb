module RubyDetective
  module AST
    module Nodes
      class ModuleDeclarationNode < GenericNode
        MODULE_NAME_NODE_INDEX = 0
        def module_name
          children[MODULE_NAME_NODE_INDEX].constant_name
        end

        # TODO: Add support for inline namespacing
        def declared_namespace
          module_name
        end
      end
    end
  end
end
