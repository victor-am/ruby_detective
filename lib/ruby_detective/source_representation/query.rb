module RubyDetective
  module SourceRepresentation
    class Query
      attr_reader :store

      def initialize(store)
        @store = store
      end

      def constants(where: {})
        constants = store.constants

        case
        when where.key?(:to)
          constants.select { |c| c.to == where[:to] }
        when where.key?(:caller)
          constants.select { |c| c.caller == where[:caller] }
        else
          constants
        end
      end

      def classes(where: {})
        classes = store.classes

        case
        when where.key?(:path)
          classes.select { |c| c.path == where[:path] }
        else
          classes
        end
      end
    end
  end
end
