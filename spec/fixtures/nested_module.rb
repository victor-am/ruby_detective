module SimpleModule
  attr_reader :name
  SOME_CONSTANT = 'Foo'

  module NestedModule
    NESTED_CONSTANT = 'Bar'

    def some_method
      NESTED_CONSTANT
    end
  end
end
