module NoName
  class RichNodeAnalyzer
    attr_reader :ast, :classes

    def initialize(rich_ast)
      @ast = rich_ast
      @classes = []
    end

    def analyze
      @classes = build_classes
    end

    private

    def build_classes
      ast.query.class_declarations.map do |class_node|
        build_class_definition_object(class_node)
      end
    end

    def build_class_definition_object(class_node)
      constants = ast.query
        .constant_references(where: { namespace: class_node.class_name })
        .map(&:constant_name)
        .uniq

      Definitions::ClassDeclaration.new(
        class_node.namespace,
        inheritance_class_name: class_node.inheritance_class_name,
        file_path: class_node.file_path,
        constant_references: constants,
        first_line: class_node.first_line,
        last_line: class_node.last_line
      )
    end
  end
end
