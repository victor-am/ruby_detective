module NoName
  module Definitions
    class ClassDeclaration
      attr_reader :name, :namespace, :file_path, :inherited_class

      def initialize(name, inherited_class: nil, file_path:, namespace:, dependencies:)
        @file_path = file_path
        @namespace = namespace
        @name = name
        @inherited_class = inherited_class
      end
    end
  end
end
