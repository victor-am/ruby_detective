require './spec/spec_helper'

RSpec.describe RubyDetective::DependencyResolver do
  let(:constant_reference) do
    RubyDetective::Representations::ConstantReferenceRepresentation.new(
      [:SimpleClass, :AnotherClass],
      file_path: "fixtures/simple_class.rb"
    )
  end

  let(:classes) do
    [
      RubyDetective::Representations::ClassRepresentation.new(
        [:SimpleClass],
        file_path: "fixtures/simple_class.rb",
        constant_references: [constant_reference],
        first_line: 1,
        last_line: 89
      ),
      RubyDetective::Representations::ClassRepresentation.new(
        [:AnotherClass],
        file_path: "fixtures/another_class.rb",
        constant_references: [],
        first_line: 1,
        last_line: 36
      )
    ]
  end

  let(:data_store) { OpenStruct.new(classes: classes) }

  it "registers the correct dependencies on the class representations" do
    subject = described_class.new(data_store)

    subject.run

    expect(classes[0].dependencies.map(&:name)).to eq([:AnotherClass])
    expect(classes[1].dependencies.map(&:name)).to eq([])
  end

  it "registers the correct dependents on the class representations" do
    subject = described_class.new(data_store)

    subject.run

    expect(classes[0].dependents.map(&:name)).to eq([])
    expect(classes[1].dependents.map(&:name)).to eq([:SimpleClass])
  end
end
