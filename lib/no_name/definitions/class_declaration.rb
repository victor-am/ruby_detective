module NoName
  module Definitions
    class ClassDeclaration
      attr_reader :namespace, :file_path, :inherited_class, :constants_referenced

      def initialize(namespace, inherited_class: nil, file_path:, constant_references:)
        @file_path = file_path
        @namespace = namespace
        @inherited_class = inherited_class
        @constants_referenced = constant_references
      end

      def name
        namespace.last
      end
    end
  end
end
