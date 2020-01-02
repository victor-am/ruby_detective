module RubyDetective
  module AST
    class Interpreter
      attr_reader :rich_ast, :classes, :file_path

      def initialize(rich_ast, file_path, data_store:)
        @rich_ast = rich_ast
        @file_path = file_path
        @data_store = data_store
      end

      def self.interpret_node_and_populate_store(*args)
        new(*args).interpret_node_and_populate_store
      end

      def interpret_node_and_populate_store
        register_classes_and_constants

        true
      end

      private
      attr_reader :data_store

      def register_classes_and_constants
        rich_ast.query.class_declarations.map do |class_node|
          class_representation = register_class(class_node)
          register_constants_referenced_in_class(class_representation)
        end
      end

      def register_class(node)
        data_store.register_class(
          node.class_name,
          node.short_namespace,
          inheritance_class_name: node.inheritance_class_name,
          file_path: node.file_path,
          first_line: node.first_line,
          last_line: node.last_line
        )
      end

      def register_constants_referenced_in_class(class_representation)
        constant_nodes = rich_ast.query
          .constant_references(where: { namespace: class_representation.name })
          .uniq{ |cr| cr.full_constant_reference_name } # Removes duplicated constants

        constant_nodes.each do |constant_node|
          data_store.register_constant(
            constant_node.constant_name,
            file_path: file_path,
            at: class_representation
          )
        end
      end
    end
  end
end
