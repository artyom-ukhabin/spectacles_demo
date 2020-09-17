# frozen_string_literal: true

module DomainServices
  class SpectacleScheduler
    attr_accessor :spectacle_repo

    def initialize(spectacle_repo)
      @spectacle_repo = spectacle_repo
    end

    def arrange_spectacle(name, start_date, end_date)
      arranged_spectacles = arranged_spectacles(start_date, end_date)
      if arranged_spectacles.present?
        [
          :error,
          arranged_spectacles.map do |arranged_spectacle|
            already_arranges_spectacle_error(arranged_spectacle)
          end.join(", ")
        ]
      else
        created_enitity = spectacle_repo.create(name, start_date, end_date)
        [:success, created_enitity]
      end
    end

    private

    def arranged_spectacles(start_date, end_date)
      spectacle_repo.get_by_dates(start_date, end_date)
    end

    def already_arranges_spectacle_error(spectacle)
      "Spectacle #{spectacle.name} already arranged " \
        "from #{spectacle.duration.first.strftime("%d.%m.%Y")} " \
        "till #{(spectacle.duration.last - 1.day).strftime("%d.%m.%Y")}"
    end
  end
end

