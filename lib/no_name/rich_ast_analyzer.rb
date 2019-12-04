module NoName
  class RichASTAnalyzer
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
      ast.query_class_declarations.map do |class_node|
        build_class_definition_object(class_node)
      end
    end

    def build_class_definition_object(node)
      constants = ast
        .query_constant_references(where: { namespace: node.class_name })
        .map(&:constant_name)
        .uniq

      Definitions::ClassDeclaration.new(
        node.namespace,
        inherited_class: node.inherited_class_name,
        file_path: node.file_path,
        constant_references: constants
      )
    end
  end
end
