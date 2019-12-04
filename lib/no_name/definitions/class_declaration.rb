module NoName
  module Definitions
    class ClassDeclaration
      attr_reader :name, :namespace, :file_path, :inherited_class, :constants_referenced

      def initialize(name, inherited_class: nil, file_path:, namespace:, constant_references:)
        @file_path = file_path
        @namespace = namespace
        @name = name
        @inherited_class = inherited_class
        @constants_referenced = constant_references
      end
    end
  end
end
