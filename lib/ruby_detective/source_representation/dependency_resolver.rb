module RubyDetective
  module SourceRepresentation
    class DependencyResolver
      attr_reader :classes

      def initialize
        @classes = DataStore.instance.classes
      end

      def self.resolve_and_populate_store
        new.resolve_and_populate_store
      end

      def resolve_and_populate_store
        register_dependencies_and_dependents
        true
      end

      private

      def register_dependencies_and_dependents
        classes.each do |klass|
          klass.constants.each do |constant|
            referred_class = find_referred_class(constant)
            next if referred_class.nil?

            constant.register_referred_class(referred_class)
          end
        end
      end

      def find_referred_class(constant)
        classes.select do |klass|
          constant.possible_paths_of_referenced_entity.find do |possible_path|
            klass.path == possible_path
          end
        end.compact.first
      end
    end
  end
end
