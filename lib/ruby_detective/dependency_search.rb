module RubyDetective
  class DependencySearch
    attr_reader :classes

    def initialize(classes)
      @classes = classes
    end

    def run
      register_dependencies
      merge_duplications

      classes
    end

    private

    def register_dependencies
      classes.each do |klass|
        constants = klass.constants_referenced.reject { |c| c == klass.name }
        dependencies = constants.map do |constant|
          classes.find { |c| c.name == constant }
        end.flatten.compact

        klass.register_dependencies(dependencies)
      end
    end

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
