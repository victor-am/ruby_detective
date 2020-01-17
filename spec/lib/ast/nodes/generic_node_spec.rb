require './spec/spec_helper'
require_relative 'ast_node_shared_example'

root_node = load_code_as_rich_ast_node(:nested_class)
deep_node = root_node.query.where(type: :generic).last

RSpec.describe RubyDetective::AST::Nodes::GenericNode do
  it_behaves_like "AST node", deep_node

  describe "#declared_namespace" do
    it "returns nil" do
      expect(deep_node.declared_namespace).to eq([])
    end
  end

  describe "#first_line" do
    it "returns the first line of the node" do
      expect(deep_node.first_line).to eq(nil)
    end
  end

  describe "#last_line" do
    it "returns the first line of the node" do
      expect(deep_node.last_line).to eq(nil)
    end
  end

  describe "type check methods" do
    it "#class_declaration_node? returns false" do
      expect(deep_node.class_declaration_node?).to eq(false)
    end

    it "#module_declaration_node? returns false" do
      expect(deep_node.module_declaration_node?).to eq(false)
    end

    it "#constant_reference_node? returns false" do
      expect(deep_node.constant_reference_node?).to eq(false)
    end

    it "#value_node? returns false" do
      expect(deep_node.value_node?).to eq(false)
    end

    it "#generic_node? returns true" do
      expect(deep_node.generic_node?).to eq(true)
    end
  end
end
