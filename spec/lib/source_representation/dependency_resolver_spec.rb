require './spec/spec_helper'

RSpec.describe RubyDetective::SourceRepresentation::DependencyResolver do
  let(:data_store) { RubyDetective::SourceRepresentation::DataStore.instance }

  before do
    simple_class = RubyDetective::SourceRepresentation::Entities::Klass.new(
      :SimpleClass,
      [],
      file_path: "fixtures/simple_class.rb",
      first_line: 1,
      last_line: 81
    )

    another_class = RubyDetective::SourceRepresentation::Entities::Klass.new(
      :AnotherClass,
      [],
      file_path: "fixtures/another_class.rb",
      first_line: 1,
      last_line: 36
    )

    constant = RubyDetective::SourceRepresentation::Entities::Constant.new(
      :SomeConstant,
      [],
      file_path: "fixtures/simple_class.rb",
      caller: simple_class,
      refers_to: another_class
    )

    data_store.classes = [simple_class, another_class]
    data_store.constants = [constant]
  end

  it "registers the correct dependencies on the class representations" do
    described_class.resolve_and_populate_store

    expect(data_store.classes[0].dependencies.map(&:name)).to eq([:AnotherClass])
    expect(data_store.classes[1].dependencies.map(&:name)).to eq([])
  end

  it "registers the correct dependents on the class representations" do
    described_class.resolve_and_populate_store

    expect(data_store.classes[0].dependents.map(&:name)).to eq([])
    expect(data_store.classes[1].dependents.map(&:name)).to eq([:SimpleClass])
  end
end
