module Errors
  class UnexpectedASTStructure < StandardError
    def initialize(msg="An unexpected AST structure was found. This is probably a bug, so please report it on our Github <3")
      super
    end
  end
end
