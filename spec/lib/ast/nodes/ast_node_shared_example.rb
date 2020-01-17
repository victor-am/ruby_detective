RSpec.shared_examples "AST node" do |node|
  describe "#query" do
    it "returns a Query object wrapping the node itself" do
      expect(node.query.node).to eq(node)
    end
  end
end
