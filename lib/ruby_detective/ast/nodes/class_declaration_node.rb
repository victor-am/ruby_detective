module RubyDetective
  module AST
    module Nodes
      class ClassDeclarationNode < GenericNode
        CLASS_NAME_NODE_INDEX = 0
        def class_name
          children[CLASS_NAME_NODE_INDEX].constant_name
        end

        INHERITANCE_CLASS_NAME_NODE_INDEX = 1
        def inheritance_class_name
          inherited_class_constant = children[INHERITANCE_CLASS_NAME_NODE_INDEX]
          # If this child isn't a ConstantReference node it means it doesn't
          # have a declared class inheritance like "class Foo::Bar"
          return unless inherited_class_constant.constant_reference_node?

          inherited_class_constant.constant_name
        end

        PREPENDED_NAMESPACE_NODE_INDEX = 0
        def declared_namespace
          prepended_namespace =
            children[CLASS_NAME_NODE_INDEX]
            .children[PREPENDED_NAMESPACE_NODE_INDEX]

          return [class_name] unless prepended_namespace.constant_reference_node?
          # This scenario happens when we have a class declaration with inline
          # namespace, like this: class MyNamespace::MyClass
          prepended_namespace.constant_path + [class_name]
        end

        def type
          :class
        end
      end
    end
  end
end
