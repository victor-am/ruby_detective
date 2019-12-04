module NoName
  module RichNodes
    class ModuleDeclarationNode < GenericNode
      # This index correspond to the child of a :module node
      # which contains the class name value as a ConstantReference node
      MODULE_NAME_NODE_INDEX = 0
      def module_name
        children[MODULE_NAME_NODE_INDEX].constant_name
      end

      private

      def namespace
        @namespace + [early_module_name]
      end

      # This is a hack since we need the module name during the initial rich AST
      # building phase, while it would only be available at the next phase when
      # we have all the child nodes sorted out
      def early_module_name
        raw_children[MODULE_NAME_NODE_INDEX].children[1]
      end
    end
  end
end
