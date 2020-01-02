require './spec/spec_helper'

RSpec.describe RubyDetective::SourceRepresentation::DependencyResolver do
  let(:data_store) { RubyDetective::SourceRepresentation::DataStore.new }

  before do
    simple_class = RubyDetective::SourceRepresentation::Entities::Klass.new(
      :SimpleClass,
      [],
      file_path: "fixtures/simple_class.rb",
      first_line: 1,
      last_line: 81,
      data_store: data_store
    )

    another_class = RubyDetective::SourceRepresentation::Entities::Klass.new(
      :AnotherClass,
      [],
      file_path: "fixtures/another_class.rb",
      first_line: 1,
      last_line: 36,
      data_store: data_store
    )

    constant = RubyDetective::SourceRepresentation::Entities::Constant.new(
      :AnotherClass,
      file_path: "fixtures/simple_class.rb",
      data_store: data_store,
      at: simple_class,
      to: another_class
    )

    data_store.instance_variable_set(:@classes, [simple_class, another_class])
    data_store.instance_variable_set(:@constants, [constant])
  end

  it "registers the correct dependencies on the class representations" do
    subject = described_class.new(data_store)

    subject.resolve_and_populate_store

    expect(data_store.classes[0].dependencies.map(&:name)).to eq([:AnotherClass])
    expect(data_store.classes[1].dependencies.map(&:name)).to eq([])
  end

  it "registers the correct dependents on the class representations" do
    subject = described_class.new(data_store)

    subject.resolve_and_populate_store

    expect(data_store.classes[0].dependents.map(&:name)).to eq([])
    expect(data_store.classes[1].dependents.map(&:name)).to eq([:SimpleClass])
  end
end
