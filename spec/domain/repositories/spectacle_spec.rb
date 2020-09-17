# frozen_string_literal: true

describe DomainRepositories::Spectacle do
  subject { described_class.new(source) }

  let(:source) { double :source }

  let(:duration) { Date.parse("21-01-2020")..Date.parse("24-01-2020") }
  let(:raw_spectacle) do
    [
      OpenStruct.new(
        name: "name 1",
        duration: duration,
      ),
    ]
  end
  let(:result) do
    [
      {
        name: "name 1",
        duration: duration,
      },
    ]
  end

  describe "#schedule" do
    let(:ordered) { double :ordered }

    before do
      allow(source).to receive(:order).with(:duration).and_return ordered
      allow(ordered).to receive(:all).and_return raw_spectacle
    end

    specify do
      expect(subject.schedule.map(&:attributes)).to match result
    end
  end

  describe "#get_by_dates" do
    let(:start_date) { "21-01-2020" }
    let(:end_date) { "24-01-2020" }
    let(:filtered) { double :filtered }

    before do
      allow(source).to receive(:where).with(
        "duration && daterange(?, ?)",
        duration.first,
        duration.last,
      ).and_return filtered
      allow(filtered).to receive(:all).and_return raw_spectacle
    end

    specify do
      expect(subject.get_by_dates(start_date, end_date).map(&:attributes)).to eq result
    end
  end

  describe "#create" do
    let(:name) { "some name" }
    let(:start_date) { "21-01-2020" }
    let(:end_date) { "24-01-2020" }
    let(:created) { double :created }

    before do
      allow(source).to receive(:create).with(
        name: name,
        duration: duration,
      ).and_return created
      allow(created).to receive(:reload).and_return raw_spectacle.first
    end

    specify do
      expect(subject.create(name, start_date, end_date).attributes).to eq result.first
    end
  end

  describe "#destroy" do
    let(:id) { 1 }
    let(:result) { "niiice" }

    before do
      allow(source).to receive(:destroy).with(id).and_return result
    end

    specify do
      expect(subject.destroy(id)).to eq result
    end
  end
end