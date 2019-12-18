require './spec/spec_helper'

RSpec.describe RubyDetective::DependencySearch do
  let(:classes) do
    [
      RubyDetective::Representations::ClassRepresentation.new(
        [:SimpleClass],
        file_path: "fixtures/simple_class.rb",
        constant_references: [:AnotherClass],
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

  it "registers the correct dependencies on the class representations" do
    subject = described_class.new(classes)

    subject.run

    expect(classes[0].dependencies.map(&:name)).to eq([:AnotherClass])
    expect(classes[1].dependencies.map(&:name)).to eq([])
  end

  it "registers the correct dependents on the class representations" do
    subject = described_class.new(classes)

    subject.run

    expect(classes[0].dependents.map(&:name)).to eq([])
    expect(classes[1].dependents.map(&:name)).to eq([:SimpleClass])
  end
end
