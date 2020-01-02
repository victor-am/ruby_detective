module RubyDetective
  module Representations
    class ConstantReferenceRepresentation
      attr_reader :name, :namespace, :file_path

      def initialize(namespace, file_path:)
        @file_path = file_path
        @namespace = namespace
        @reference_to = nil
        @reference_at = nil
      end

      def name
        namespace.last
      end

      def full_name
        namespace.join("::")
      end

      def register_referred_class(klass)
        @reference_to = klass
      end
    end
  end
end
