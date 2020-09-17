# frozen_string_literal: true

describe SpectacleDecorator do
  subject { described_class.decorate(spectacle) }

  let(:spectacle) do
    DomainEntities::Spectacle.new(
      name: "name",
      duration: Date.parse("20-01-2020")..Date.parse("20-01-2020") + 2.day
    )
  end

  context "#duration" do
    let(:result) { "20.01.2020 - 21.01.2020" }

    specify do
      expect(subject.duration).to eq result
    end
  end

  context "#serialize" do
    let(:result) do
      { name: "name", duration: "20.01.2020 - 21.01.2020" }.to_json
    end

    specify do
      expect(subject.serialize).to eq result
    end
  end
end