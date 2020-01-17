require './spec/spec_helper'

RSpec.describe RubyDetective::SourceRepresentation::Query do
  let(:data_store) { RubyDetective::SourceRepresentation::DataStore.instance }

  let(:simple_class) do
    RubyDetective::SourceRepresentation::Entities::Klass.new(
      :SimpleClass,
      [],
      file_path: "fixtures/simple_class.rb",
      first_line: 1,
      last_line: 81
    )
  end

  let(:another_class) do
    RubyDetective::SourceRepresentation::Entities::Klass.new(
      :AnotherClass,
      [],
      file_path: "fixtures/another_class.rb",
      first_line: 1,
      last_line: 36
    )
  end

  let(:constant) do
    RubyDetective::SourceRepresentation::Entities::Constant.new(
      :SomeConstant,
      [],
      file_path: "fixtures/simple_class.rb",
      caller: simple_class,
      refers_to: another_class
    )
  end

  before do
    data_store.classes = [simple_class, another_class]
    data_store.constants = [constant]
  end

  describe "#constants" do
    it "returns all the constants" do
      query = described_class.new
      expect(query.constants.map(&:name)).to eq([:SomeConstant])
    end

    it "returns only matching constants when filtered by caller" do
      query = described_class.new
      expect(query.constants(where: { caller: simple_class }).map(&:name)).to eq([:SomeConstant])
      expect(query.constants(where: { caller: another_class }).map(&:name)).to eq([])
    end

    it "returns only matching constants when filtered by refers_to" do
      query = described_class.new
      expect(query.constants(where: { refers_to: another_class }).map(&:name)).to eq([:SomeConstant])
      expect(query.constants(where: { refers_to: simple_class }).map(&:name)).to eq([])
    end
  end

  describe "#classes" do
    it "returns all the classes" do
      query = described_class.new
      expect(query.classes.map(&:name)).to eq([:SimpleClass, :AnotherClass])
    end

    it "returns only matching classes when filtered by path" do
      query = described_class.new
      expect(query.classes(where: { path: simple_class.path }).map(&:name)).to eq([:SimpleClass])
      expect(query.classes(where: { path: [:foo, :bar] }).map(&:name)).to eq([])
    end
  end
end
