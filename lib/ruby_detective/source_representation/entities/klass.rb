module RubyDetective
  module SourceRepresentation
    module Entities
      class Klass
        attr_reader :name, :namespace, :file_path, :inheritance_class_name, :lines_of_code

        def initialize(name, namespace, inheritance_class_name: nil, file_path:, first_line:, last_line:, data_store:)
          @name = name
          @namespace = namespace
          @file_path = file_path
          @inheritance_class_name = inheritance_class_name
          @lines_of_code = last_line - first_line + 1
          @data_store = data_store
        end

        def full_name
          full_namespace.join("::")
        end

        def full_namespace
          namespace + [name]
        end

        def constants
          data_store.query
          .constants(where: { at: self })
        end

        def dependencies
          constants
          .map(&:to)
          .compact
          .reject{ |c| c.name == name } # Removes circular dependencies
        end

        def dependents
          data_store.query
          .constants(where: { to: self })
          .map(&:at)
          .compact
          .reject{ |c| c.name == name } # Removes circular dependencies
        end

        def merge(duplicate)
          @inheritance_class_name ||= duplicate.inheritance_class_name
          @lines_of_code += duplicate.lines_of_code
        end

        private
        attr_reader :data_store
      end
    end
  end
end
