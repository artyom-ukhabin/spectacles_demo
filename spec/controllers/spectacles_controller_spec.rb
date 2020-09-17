# frozen_string_literal: true

describe SpectaclesController do
  describe "#index" do
    let(:today) { Date.parse("20-01-2020") }
    let!(:spectacle1) do
      create :spectacle,
             name: "Spectacle 1",
             duration: today + 2.days..today + 6.days
    end
    let!(:spectacle2) do
      create :spectacle,
             name: "Spectacle 2",
             duration: today - 2.days..today - 1.days
    end
    let!(:spectacle3) do
      create :spectacle,
             name: "Spectacle 3",
             duration: today..today + 1.days
    end

    let(:result_body) do
      {
        "old" => [
          { "name" => "Spectacle 2", "duration" => "18.01.2020 - 19.01.2020" },
        ],
        "actual" => [
          { "name" => "Spectacle 3", "duration" => "20.01.2020 - 21.01.2020" },
          { "name" => "Spectacle 1", "duration" => "22.01.2020 - 26.01.2020" },
        ],
      }
    end

    specify do
      timecopped(today) do
        get :index
        expect(Spectacle.count).to eq 3
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq result_body
      end
    end
  end

  describe "#create" do
    context "success" do
      let(:params) do
        {
          name: "Spectacle 2",
          start_date: "20-01-2020",
          end_date: "22-01-2020",
        }
      end
      let(:result_body) do
        {
          "name" => "Spectacle 2",
          "duration" => "20.01.2020 - 22.01.2020",
        }
      end

      specify do
        expect(Spectacle.count).to eq 0
        post(:create, params: params)
        expect(Spectacle.count).to eq 1
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq result_body
      end
    end

    context 'error' do
      let(:today) { Date.parse("20-01-2020") }
      let!(:spectacle1) do
        create :spectacle,
               name: "Spectacle 1",
               duration: today..today + 2.days
      end
      let!(:spectacle2) do
        create :spectacle,
               name: "Spectacle 2",
               duration: today + 3.days..today + 4.days
      end
      let!(:spectacle3) do
        create :spectacle,
               name: "Spectacle 3",
               duration: today + 5.days..today + 6.days
      end

      let(:params) do
        {
          name: "Spectacle 2",
          start_date: "21-01-2020",
          end_date: "27-01-2020",
        }
      end
      let(:result_body) do
        {
          "error" =>
            "Spectacle Spectacle 1 already arranged from 20.01.2020 till 22.01.2020, " \
              "Spectacle Spectacle 2 already arranged from 23.01.2020 till 24.01.2020, " \
              "Spectacle Spectacle 3 already arranged from 25.01.2020 till 26.01.2020"
        }
      end

      specify do
        expect(Spectacle.count).to eq 3
        post(:create, params: params)
        expect(response.status).to eq 422
        expect(JSON.parse(response.body)).to eq result_body
        expect(Spectacle.count).to eq 3
        expect(Spectacle.first).to eq spectacle1
      end
    end

  end

  describe "#destroy" do
    let!(:spectacle1) { create :spectacle }
    let!(:spectacle2) { create :spectacle }

    before do
      expect(Spectacle.count).to eq 2
    end

    context "success" do
      let(:result_body) { "Success!" }

      specify do
        delete(:destroy, params: { id: spectacle1.id })

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq result_body
        expect(Spectacle.count).to eq 1
        expect(Spectacle.first).to eq spectacle2
      end
    end

    context "error" do
      let(:wrong_id) { spectacle1.id + spectacle2.id }
      let(:result_body) { { "error" => "Couldn't find Spectacle with 'id'=#{wrong_id}" } }

      specify do
        delete(:destroy, params: { id: wrong_id })

        expect(response.status).to eq 500
        expect(JSON.parse(response.body)).to eq result_body
        expect(Spectacle.count).to eq 2
        expect(Spectacle.first).to eq spectacle1
      end
    end
  end
end