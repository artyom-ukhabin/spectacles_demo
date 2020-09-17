# frozen_string_literal: true

module DomainRepositories
  class Spectacle
    attr_accessor :source

    def initialize(source)
      @source = source
    end

    def schedule
      result = source.order(:duration).all
      to_entities(result)
    end

    def get_by_dates(start_date, end_date)
      duration = Date.parse(start_date)..Date.parse(end_date)
      result = source.where("duration && daterange(?, ?)", duration.first, duration.last).all
      to_entities(result)
    end

    def create(name, start_date, end_date)
      created_spectacle = source.create(
        name: name,
        duration: Date.parse(start_date)..Date.parse(end_date),
      )
      created_spectacle = created_spectacle.reload
      to_entity(created_spectacle)
    end

    def destroy(id)
      source.destroy(id)
    end

    private

    def to_entity(spectacle)
      DomainEntities::Spectacle.new(
        name: spectacle.name,
        duration: spectacle.duration,
      )
    end

    def to_entities(spectacles)
      spectacles.map { |spectacle| to_entity(spectacle) }
    end
  end
end

