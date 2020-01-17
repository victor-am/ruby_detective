module RubyDetective
  module SourceRepresentation
    class Query
      attr_reader :store

      def initialize
        @store = DataStore.instance
      end

      def constants(where: {})
        constants = store.constants

        case
        when where.key?(:refers_to)
          constants.select { |c| c.refers_to == where[:refers_to] }
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
