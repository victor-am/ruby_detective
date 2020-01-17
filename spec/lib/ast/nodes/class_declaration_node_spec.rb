require './spec/spec_helper'
require_relative 'ast_node_shared_example'

root_node = load_code_as_rich_ast_node(:nested_class)
deep_node = root_node.query.where(type: :class).last

RSpec.describe RubyDetective::AST::Nodes::ClassDeclarationNode do
  it_behaves_like "AST node", deep_node

  describe "#class_name" do
    it "returns the name of the class declared by the node" do
      expect(deep_node.class_name).to eq(:NestedClass)
    end
  end

  describe "#inheritance_class_name" do
    it "returns nil if no class" do
      expect(deep_node.inheritance_class_name).to eq(nil)
    end
  end

  describe "#declared_namespace" do
    it "returns the namespace declared by the node" do
      expect(deep_node.declared_namespace).to eq([:NestedClass])
    end
  end

  describe "#first_line" do
    it "returns the first line of the node" do
      expect(deep_node.first_line).to eq(11)
    end
  end

  describe "#last_line" do
    it "returns the first line of the node" do
      expect(deep_node.last_line).to eq(17)
    end
  end

  describe "type check methods" do
    it "#class_declaration_node? returns false" do
      expect(deep_node.class_declaration_node?).to eq(true)
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
      expect(deep_node.generic_node?).to eq(false)
    end
  end
end
