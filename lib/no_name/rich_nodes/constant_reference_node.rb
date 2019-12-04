module NoName
  module RichNodes
    class ConstantReferenceNode < GenericNode
      # This index correspond to the child of a ConstantReference node
      # which contains the constant name value as a Value node
      CONSTANT_NAME_INDEX = 1
      def constant_name
        children[CONSTANT_NAME_INDEX].value
      end
    end
  end
end
