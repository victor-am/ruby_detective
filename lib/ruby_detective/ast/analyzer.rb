module RubyDetective
  module AST
    class Analyzer
      attr_reader :rich_ast, :classes, :file_path

      def initialize(code, file_path)
        @code = code
        @classes = []
        @file_path = file_path
      end

      def run
        raw_ast = Parser::CurrentRuby.parse(@code)
        return false if raw_ast.nil? # Empty file scenario

        @rich_ast = AST::NodeFactory.build(raw_ast, file_path: file_path)
        rich_ast.process_all_children!

        @classes = build_classes

        true
      end

      private

      def build_classes
        rich_ast.query.class_declarations.map do |class_node|
          build_class_definition_object(class_node)
        end
      end

      def build_class_definition_object(class_node)
        constants = build_constant_references(class_node)

        Representations::ClassRepresentation.new(
          class_node.namespace,
          inheritance_class_name: class_node.inheritance_class_name,
          file_path: class_node.file_path,
          constant_references: constants,
          first_line: class_node.first_line,
          last_line: class_node.last_line
        )
      end

      def build_constant_references(class_node)
        constant_nodes = rich_ast.query
          .constant_references(where: { namespace: class_node.class_name })
          .uniq{ |cr| cr.full_constant_reference_name }

        constant_nodes.map do |node|
          Representations::ConstantReferenceRepresentation.new(
            node.namespace + [node.constant_name],
            file_path: node.file_path
          )
        end
      end
    end
  end
end
