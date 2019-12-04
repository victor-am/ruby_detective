module NoName
  class FileParser
    attr_reader :path, :raw_ast, :rich_ast

    def initialize(file_path)
      @path = file_path
    end

    def parse
      @code = File.read(path)
      @raw_ast = Parser::CurrentRuby.parse(@code)
      @rich_ast = RichNodes::Factory.build(raw_ast, file_path: path)
      
      rich_ast.process_all_children!
    end

    def class_definitions
      rich_ast.class_definitions
    end

    def module_definitions
      rich_ast.module_definitions
    end

    def inheritance_definitions
      rich_ast.inheritance_definitions
    end
  end
end
