require './spec/spec_helper'

RSpec.describe RubyDetective::AST::Interpreter do
  let(:data_store) { RubyDetective::SourceRepresentation::DataStore.instance }
  before { data_store.clear! }

  it "finds and registers all classes in the data store" do
    rich_ast = load_code_as_rich_ast_node(:nested_class)
    subject = described_class.new(rich_ast, "fixtures/nested_class.rb")
    subject.interpret_node_and_populate_store

    expect(data_store.classes.map(&:name)).to eq([:SimpleClass, :NestedClass])
  end

  it "finds and registers all constants in the data store" do
    rich_ast = load_code_as_rich_ast_node(:nested_class)
    subject = described_class.new(rich_ast, "fixtures/nested_class.rb")
    subject.interpret_node_and_populate_store

    expected_constants = [
      :NESTED_CONSTANT,
      :NESTED_CONSTANT,
      :NestedClass,
      :NestedClass,
      :OtherClass,
      :SOME_CONSTANT,
      :SimpleClass
    ]

    expect(data_store.constants.map(&:name)).to contain_exactly(*expected_constants)
  end
end
