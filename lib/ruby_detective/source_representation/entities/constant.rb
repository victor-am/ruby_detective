module RubyDetective
  module SourceRepresentation
    module Entities
      class Constant
        attr_reader :name, :file_path, :at, :to

        def initialize(name, file_path:, at:, to: nil, data_store:)
          @name = name
          @file_path = file_path
          @to = to
          @at = at
          @data_store = data_store
        end

        def full_name
          full_namespace.join("::")
        end

        def full_namespace
          namespace + [name]
        end

        def namespace
          at.namespace
        end

        def register_referred_class(klass)
          @to = klass
        end

        private
        attr_reader :data_store
      end
    end
  end
end
