RSpec.shared_examples "AST node" do |node|
  describe "#namespace" do
    it "generates the namespace correctly" do
      expect(node.namespace).to eq([:SimpleClass, :NestedClass])
    end
  end

  describe "#query" do
    it "returns a Query object wrapping the node itself" do
      expect(node.query.node).to eq(node)
    end
  end

  describe "#process_all_children!" do
    it "recursively creates rich children nodes associated to it" do
      raw_node = load_code_as_raw_ast_node(:simple_class)
      rich_node = described_class.new(
        raw_node,
        file_path: "fixtures/simple_class.rb",
        parent_node: nil
      )

      rich_node.process_all_children!

      expect(rich_node.children.length).to eq(3)
    end
  end
end
