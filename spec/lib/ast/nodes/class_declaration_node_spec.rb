require './spec/spec_helper'
require_relative 'ast_node_shared_example'

root_node = load_code_as_rich_ast_node(:nested_class)
subject = root_node.query.where(type: :class).last

RSpec.describe RubyDetective::AST::Nodes::ClassDeclarationNode do
  it_behaves_like "AST node", subject

  describe "#namespace" do
    it "generates the namespace correctly" do
      expect(subject.namespace).to eq([:SimpleClass, :NestedClass])
    end
  end

  describe "#class_name" do
    it "returns the name of the class declared by the node" do
      expect(subject.class_name).to eq(:NestedClass)
    end
  end

  describe "#inheritance_class_name" do
    it "returns nil if no class" do
      expect(subject.inheritance_class_name).to eq(nil)
    end
  end

  describe "#declared_namespace" do
    it "returns the namespace declared by the node" do
      expect(subject.declared_namespace).to eq([:NestedClass])
    end
  end

  describe "#first_line" do
    it "returns the first line of the node" do
      expect(subject.first_line).to eq(11)
    end
  end

  describe "#last_line" do
    it "returns the first line of the node" do
      expect(subject.last_line).to eq(17)
    end
  end

  describe "type check methods" do
    it "#class_declaration_node? returns true" do
      expect(subject.class_declaration_node?).to eq(true)
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
      expect(subject.generic_node?).to eq(false)
    end
  end
end
