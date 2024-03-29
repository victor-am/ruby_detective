module RubyDetective
  module SourceRepresentation
    module Entities
      class Constant < Base
        attr_reader :name, :namespace, :file_path, :caller, :refers_to

        def initialize(name, namespace, file_path:, caller:, refers_to: nil)
          @name = name
          @namespace = namespace
          @file_path = file_path
          @refers_to = refers_to
          @caller = caller
          @data_store = SourceRepresentation::DataStore.instance
        end

        def caller_namespace
          caller.namespace
        end

        def register_referred_class(klass)
          @refers_to = klass
        end

        def possible_paths_of_referenced_entity
          # If the constant was like "::Foo::Bar" there is only one possible
          # match: the exact path described in the constant
          return [path_without_root_sign] if absolute_path?

          possible_parent_namespaces
          .map { |possible_parent| possible_parent + path }
          .push(path)
        end

        private
        attr_reader :data_store

        def possible_parent_namespaces
          (caller_namespace.size - 1)
          .downto(0)
          .map { |i| caller_namespace[0..i] }
        end
      end
    end
  end
end
