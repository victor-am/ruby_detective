module NoName
  module Definitions
    class ClassDeclaration
      attr_reader :name, :file_path, :inherited_class

      def initialize(name, inherited_class: nil, file_path:, dependencies:)
        @name = name
        @file_path = file_path
        @inherited_class = inherited_class
      end
    end
  end
end
