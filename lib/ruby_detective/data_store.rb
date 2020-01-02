# This class is used as a database of sorts during the
# analysis execution.
module RubyDetective
  class DataStore
    attr_reader :classes, :modules, :constant_references

    def initialize
      @classes = []
      @modules = []
      @constant_references = []
    end

    def all_entities
      @classes + @modules
    end

    def add_classes(classes)
      @classes += classes
    end

    def add_constant_reference(constant)
      @constant_references << constant
    end
  end
end
