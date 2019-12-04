module NoName
  module RichNodes
    class ModuleDeclarationNode < GenericNode
      # This index correspond to the child of a :module node
      # which contains the class name value as a ConstantReference node
      MODULE_NAME_NODE_INDEX = 0
      def module_name
        children[MODULE_NAME_NODE_INDEX].constant_name
      end
    end
  end
end
