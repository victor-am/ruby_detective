require "singleton"

# This class is used as a database of sorts during the
# analysis execution.
module RubyDetective
  module SourceRepresentation
    class DataStore
      include Singleton

      attr_accessor :classes, :modules, :constants

      def initialize
        @classes = []
        @modules = []
        @constants = []
      end

      def query
        Query.new(self)
      end

      def inspect
        "#<RubyDetective::SourceRepresentation::DataStore>"
      end

      def resolve_dependencies
        DependencyResolver.resolve_and_populate_store
      end

      def register_class(name, namespace, inheritance_class_name:, file_path:, first_line:, last_line:)
        klass = Entities::Klass.new(
          name,
          namespace,
          inheritance_class_name: inheritance_class_name,
          file_path: file_path,
          first_line: first_line,
          last_line: last_line
        )

        existing_class = query.classes(where: { path: klass.path }).first

        if existing_class
          existing_class.merge(klass)
          existing_class
        else
          @classes << klass
          klass
        end
      end

      def register_constant(name, namespace, file_path:, caller:, to: nil)
        constant = Entities::Constant.new(
          name,
          namespace,
          caller: caller,
          to: to,
          file_path: file_path
        )
        @constants << constant
        constant
      end
    end
  end
end
