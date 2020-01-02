module RubyDetective
  module SourceRepresentation
    class DependencyResolver
      attr_reader :classes

      def initialize(data_store)
        @classes = data_store.classes
      end

      def self.resolve_and_populate_store(*args)
        new(*args).resolve_and_populate_store
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
        possible_matches = classes.map do |entity|
          match_score = calculate_match_score_through_cascading(constant, entity)
          { match_score: match_score, entity: entity }
        end.reject{ |pm| pm[:match_score] == 0 }

        possible_matches.sort_by{ |e| e[:match_score] }.first&.fetch(:entity)
      end

      def calculate_match_score_through_cascading(constant, entity)
        constant.full_namespace.reverse.each_with_index.take_while do |name, index|
          entity.full_namespace.reverse[index] == name
        end.size
      end
    end
  end
end
