# frozen_string_literal: true

describe DomainServices::SpectacleScheduler do
  subject { described_class.new(spectacle_repo) }

  let(:spectacle_repo) { double :spectacle_repo }

  describe "#arrance_spectacle" do
    let(:name) { "name" }
    let(:start_date) { "21-01-2020" }
    let(:end_date) { "24-01-2020" }
    let(:created_spectacle) do
      OpenStruct.new(
        name: "name 1",
        duration: Date.parse("21-01-2020")..Date.parse("24-01-2020")
      )
    end

    context "success" do
      before do
        allow(spectacle_repo).to receive(:get_by_dates).and_return []
        allow(spectacle_repo)
          .to receive(:create).with(name, start_date, end_date).and_return(created_spectacle)
      end

      specify do
        expect(subject.arrange_spectacle(name, start_date, end_date))
          .to eq [:success, created_spectacle]
      end
    end

    context "failure" do
      let(:existed_spectacles) do
        [
          OpenStruct.new(
            name: "name 1",
            duration: Date.parse("20-01-2020")..Date.parse("22-01-2020")
          ),
          OpenStruct.new(
            name: "name 2",
            duration: Date.parse("22-01-2020")..Date.parse("24-01-2020")
          ),
        ]
      end
      let(:error) do
        "Spectacle name 1 already arranged from 20.01.2020 till 21.01.2020, " \
        "Spectacle name 2 already arranged from 22.01.2020 till 23.01.2020"
      end

      before do
        allow(spectacle_repo).to receive(:get_by_dates).and_return existed_spectacles
      end

      specify do
        expect(subject.arrange_spectacle(name, start_date, end_date)).to eq [:error, error]
      end
    end
  end

end