require './spec/spec_helper'
require_relative 'ast_node_shared_example'

root_node = load_code_as_rich_ast_node(:nested_class)
subject = root_node.query.where(type: :generic).last

RSpec.describe RubyDetective::AST::Nodes::GenericNode do
  it_behaves_like "AST node", subject

  describe "#namespace" do
    it "generates the namespace correctly" do
      expect(subject.namespace).to eq([:SimpleClass, :NestedClass])
    end
  end

  describe "#declared_namespace" do
    it "returns nil" do
      expect(subject.declared_namespace).to eq([])
    end
  end

  describe "#first_line" do
    it "returns the first line of the node" do
      expect(subject.first_line).to eq(nil)
    end
  end

  describe "#last_line" do
    it "returns the first line of the node" do
      expect(subject.last_line).to eq(nil)
    end
  end

  describe "type check methods" do
    it "#class_declaration_node? returns false" do
      expect(subject.class_declaration_node?).to eq(false)
    end

    it "#module_declaration_node? returns false" do
      expect(subject.module_declaration_node?).to eq(false)
    end

    it "#constant_reference_node? returns false" do
      expect(subject.constant_reference_node?).to eq(false)
    end

    it "#value_node? returns false" do
      expect(subject.value_node?).to eq(false)
    end

    it "#generic_node? returns true" do
      expect(subject.generic_node?).to eq(true)
    end
  end
end
