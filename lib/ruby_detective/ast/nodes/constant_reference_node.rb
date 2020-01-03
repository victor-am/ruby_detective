module RubyDetective
  module AST
    module Nodes
      class ConstantReferenceNode < GenericNode
        CONSTANT_NAME_INDEX = 1
        def constant_name
          children[CONSTANT_NAME_INDEX].value
        end

        # A top level constant is for example the "Bar" from "Foo::Bar".
        # We access it by checking if the parent is another constant, if it is
        # it means the constant is a nested one and not top level.
        def top_level_constant?
          !parent_node.constant_reference_node?
        end

        # Recursively builds the constant path by traversing it's children,
        # that way we can compose a path composed of multiple namespaces,
        # for example: Foo::Bar::Batz as [:Foo, :Bar, :Batz].
        NESTED_CONSTANT_INDEX = 0
        def constant_path
          nested_constant = children[NESTED_CONSTANT_INDEX]

          if nested_constant.constant_reference_node?
            nested_constant.constant_path + [constant_name]
          elsif nested_constant.root_sign_node?
            # This is used to signify that the constant path was forced to start
            # from the root, for example: "::Foo::Bar"
            [:"::"] + [constant_name]
          else
            [constant_name]
          end
        end

        def type
          :constant
        end
      end
    end
  end
end
