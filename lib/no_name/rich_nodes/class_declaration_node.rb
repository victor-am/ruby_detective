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

      # The content of this method is kinda hacky since we need the namespaces
      # during the initial rich AST building phase, while it would only be
      # available at the next phase when we have all the child nodes sorted out
      PREPENDED_NAMESPACE_NODE_INDEX = 0
      def namespace
        prepended_namespace = ast_node.children[CLASS_NAME_NODE_INDEX].children[PREPENDED_NAMESPACE_NODE_INDEX]

        # This condition is true when we have a class declaration with inline
        # namespace, like this: class MyNamespace::MyClass
        if prepended_namespace != nil
          @namespace + [early_class_name] + recursively_extract_namespaces(prepended_namespace)
        else
          @namespace + [early_class_name]
        end
      end

      private

      def recursively_extract_namespaces(node, accumulator = [])
        return accumulator.reverse if node.nil?

        namespace = node.children[1]
        accumulator << namespace
        recursively_extract_namespaces(node.children[0], accumulator)
      end

      # This is a hack since we need the class name during the initial rich AST
      # building phase, while it would only be available at the next phase when
      # we have all the child nodes sorted out
      def early_class_name
        raw_children[CLASS_NAME_NODE_INDEX].children[1]
      end
    end
  end
end
