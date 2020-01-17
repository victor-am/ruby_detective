FIXTURES_PATH =  "#{File.dirname(__FILE__)}/../fixtures/"

def load_code_as_raw_ast_node(file_name)
  code = File.read(FIXTURES_PATH + file_name.to_s + ".rb")
  Parser::CurrentRuby.parse(code)
end

def load_code_as_rich_ast_node(file_name)
  ast_node = load_code_as_raw_ast_node(file_name)
  factory = RubyDetective::AST::NodeFactory.new(ast_node, file_path: "fixtures/#{file_name}.rb")
  rich_node = factory.build
  factory.process_all_children

  rich_node
end
