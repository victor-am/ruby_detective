# This class is used as a database of sorts during the
# analysis execution.
module RubyDetective
  module SourceRepresentation
    class DataStore
      attr_reader :classes, :modules, :constants

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
        SourceRepresentation::DependencyResolver.resolve_and_populate_store(self)
      end

      def register_class(name, namespace, inheritance_class_name:, file_path:, first_line:, last_line:)
        klass = Entities::Klass.new(
          name,
          namespace,
          data_store: self,
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
          data_store: self,
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
