module RubyDetective
  class DependencyResolver
    attr_reader :classes

    def initialize(data_store)
      @classes = data_store.classes
    end

    def run
      register_dependencies_and_dependents
      merge_duplications
      true
    end

    private

    def register_dependencies_and_dependents
      classes.each do |klass|
        klass.constant_references.each do |constant|
          referred_class = find_referred_class(constant)
          next if referred_class.nil?

          constant.register_referred_class(referred_class)
          klass.register_dependencies([referred_class])
          referred_class.register_dependents([klass])
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
      constant.namespace.reverse.each_with_index.take_while do |name, index|
        entity.namespace.reverse[index] == name
      end.size
    end

    # TODO: move this to another place
    def merge_duplications
      @classes = classes.group_by(&:full_name).map do |_full_name, group|
        if group.size == 1
          group
        else
          group.first.merge_information(group[1..-1])
          [group.first]
        end
      end.flatten
    end
  end
end
