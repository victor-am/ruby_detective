class SimpleClass
  attr_reader :name

  SOME_CONSTANT = 'Foo'
  
  def initialize
    @name = SOME_CONSTANT
    @type = OtherClass.new
  end
end
