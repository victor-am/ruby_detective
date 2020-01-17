require './spec/spec_helper'
require_relative 'ast_node_shared_example'

root_node = load_code_as_rich_ast_node(:nested_module)
subject = root_node.query.where(type: :module).last

RSpec.describe RubyDetective::AST::Nodes::ModuleDeclarationNode do
  it_behaves_like "AST node", subject

  describe "#namespace" do
    it "generates the namespace correctly" do
      expect(subject.namespace).to eq([:SimpleModule, :NestedModule])
    end
  end

  describe "#module_name" do
    it "returns the name of the module declared by the node" do
      expect(subject.module_name).to eq(:NestedModule)
    end
  end

  describe "#declared_namespace" do
    it "returns the namespace declared by the node" do
      expect(subject.declared_namespace).to eq([:NestedModule])
    end
  end

  describe "#first_line" do
    it "returns the first line of the node" do
      expect(subject.first_line).to eq(5)
    end
  end

  describe "#last_line" do
    it "returns the first line of the node" do
      expect(subject.last_line).to eq(11)
    end
  end

  describe "type check methods" do
    it "#class_declaration_node? returns false" do
      expect(subject.class_declaration_node?).to eq(false)
    end

    it "#module_declaration_node? returns true" do
      expect(subject.module_declaration_node?).to eq(true)
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
