module RubyDetective
  module AST
    module Nodes
      class GenericNode
        attr_reader :ast_node, :children, :file_path, :parent_node

        def initialize(ast_node, file_path:, parent_node:)
          @ast_node = ast_node
          @file_path = file_path
          @children = []
          @parent_node = parent_node
        end

        def short_namespace
          namespace[0..-2]
        end

        def namespace
          build_namespace(self)
        end

        def declared_namespace
          []
        end

        def class_declaration_node?
          type == :class
        end

        def module_declaration_node?
          type == :module
        end

        def constant_reference_node?
          type == :constant
        end

        def absolute_path_sign_node?
          type == :absolute_path_sign
        end

        def value_node?
          type == :value
        end

        def generic_node?
          type == :generic
        end

        def type
          :generic
        end

        def first_line
          # When the node represents something that is not directly in the code
          # the `ast_node.loc.expression` can be nil, and since `.line` is just
          # sugar syntax for `loc.expression.line` it would throw an error.
          ast_node.loc.line rescue nil
        end

        def last_line
          # When the node represents something that is not directly in the code
          # the `ast_node.loc.expression` can be nil, and since `.last_line` is just
          # sugar syntax for `loc.expression.last_line` it would throw an error.
          ast_node.loc.last_line rescue nil
        end

        def query
          Query.new(self)
        end

        def raw_children
          ast_node.children
        end

        private

        def build_namespace(node, acc = [])
          return acc.flatten.compact if node.nil?

          acc.prepend(node.declared_namespace)
          build_namespace(node.parent_node, acc)
        end
      end
    end
  end
end
