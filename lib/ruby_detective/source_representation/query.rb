module RubyDetective
  module SourceRepresentation
    class Query
      attr_reader :store

      def initialize(store)
        @store = store
      end

      def constants(where: {})
        constants = store.constants

        case where
        when -> (w) { w.key?(:to) }
          constants.select { |c| c.to == where[:to] }
        when -> (w) { w.key?(:at) }
          constants.select { |c| c.at == where[:at] }
        else
          constants
        end
      end

      def classes(where: {})
        classes = store.classes

        case where
        when -> (w) { w.key?(:full_name) }
          classes.select { |c| c.full_name == where[:full_name] }
        else
          classes
        end
      end
    end
  end
end
