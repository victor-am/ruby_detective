module NoName
  module Definitions
    class ClassDeclaration
      attr_reader :namespace, :file_path, :inheritance_class_name, :constants_referenced, :dependencies

      def initialize(namespace, inheritance_class_name: nil, file_path:, constant_references:)
        @file_path = file_path
        @namespace = namespace
        @inheritance_class_name = inheritance_class_name
        @constants_referenced = constant_references
        @dependencies = []
      end

      def name
        namespace.last
      end

      def full_name
        namespace.join('::')
      end

      def register_dependencies(dependencies)
        @dependencies += dependencies
      end
    end
  end
end
