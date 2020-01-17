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
end
