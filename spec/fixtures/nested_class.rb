class SimpleClass
  attr_reader :name

  SOME_CONSTANT = 'Foo'

  def initialize
    @name = SOME_CONSTANT
    @type = OtherClass.new
  end

  class NestedClass
    NESTED_CONSTANT = 'Bar'

    def self.some_method
      NESTED_CONSTANT
    end
  end
end
