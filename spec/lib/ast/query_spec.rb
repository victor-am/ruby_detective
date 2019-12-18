require './spec/spec_helper'

RSpec.describe RubyDetective::AST::Query do
  describe "#constant_references" do
    it "returns all the constants referenced in the node" do
      node = load_code_as_rich_ast_node(:simple_class)
      subject = RubyDetective::AST::Query.new(node)

      results = subject.constant_references

      expect(results.map(&:constant_name)).to eq([:SimpleClass, :SOME_CONSTANT, :OtherClass])
    end

    it "returns only matched constants when filtered by where" do
      node = load_code_as_rich_ast_node(:nested_class)
      subject = RubyDetective::AST::Query.new(node)

      results = subject.constant_references(where: { namespace: :NestedClass })

      expect(results.map(&:constant_name)).to eq([:NestedClass, :NESTED_CONSTANT])
    end
  end

  describe "#class_declarations" do
    it "returns all the classes declared in the node" do
      node = load_code_as_rich_ast_node(:nested_class)
      subject = RubyDetective::AST::Query.new(node)

      results = subject.class_declarations

      expect(results.map(&:class_name)).to eq([:SimpleClass, :NestedClass])
    end
  end
end