module NoName
  module RichNodes
    class ConstantReferenceNode < GenericNode
      CONSTANT_NAME_INDEX = 1
      def constant_name
        children[CONSTANT_NAME_INDEX].value
      end
    end
  end
end
