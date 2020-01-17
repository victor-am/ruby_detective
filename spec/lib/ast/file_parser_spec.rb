require './spec/spec_helper'

RSpec.describe RubyDetective::AST::FileParser do
  let(:data_store) { RubyDetective::SourceRepresentation::DataStore.instance }
  before { data_store.clear! }

  it "parses the file to a rich AST" do
    file_path = "#{FIXTURES_PATH}/simple_class.rb"
    project_path = FIXTURES_PATH

    subject = described_class.new(file_path, project_path)
    subject.parse

    expect(subject.rich_ast).to be_a(RubyDetective::AST::Nodes::GenericNode)
  end

  it "removes the project path from the file path" do
    file_path = "#{FIXTURES_PATH}/simple_class.rb"
    project_path = FIXTURES_PATH

    subject = described_class.new(file_path, project_path)
    subject.parse

    expect(data_store.classes.first.file_path).to eq("/simple_class.rb")
  end
end
