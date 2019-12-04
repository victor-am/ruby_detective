module NoName
  module RichNodes
    class ClassDeclarationNode < GenericNode
      # This index correspond to the child of a ClassDeclaration node
      # which contains the class name value as a ConstantReference node
      CLASS_NAME_NODE_INDEX = 0
      def class_name
        children[CLASS_NAME_NODE_INDEX].constant_name
      end

      # This index correspond to the child of a ClassDeclaration node which
      # contains the inherited class name value as a ConstantReference node
      INHERITED_CLASS_NAME_NODE_INDEX = 1
      def inherited_class_name
        inherited_class_constant = children[INHERITED_CLASS_NAME_NODE_INDEX]
        # If this child isn't a ConstantReference node it means it doesn't
        # have a declared class inheritance
        return unless inherited_class_constant.constant_reference_node?

        inherited_class_constant.constant_name
      end

      def class_definitions
        super << build_class_definition_object
      end

      private

      def build_class_definition_object
        Definitions::ClassDeclaration.new(
          class_name,
          inherited_class: inherited_class_name,
          file_path: file_path,
          dependencies: []
        )
      end
    end
  end
end
