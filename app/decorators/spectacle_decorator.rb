# frozen_string_literal: true

class SpectacleDecorator < ApplicationDecorator
  def duration
    original_duration = attributes[:duration]
    start_date = original_duration.first.strftime("%d.%m.%Y")
    end_date = (original_duration.last - 1.day).strftime("%d.%m.%Y")
    "#{start_date} - #{end_date}"
  end

  def serialize
    to_jbuilder.target!
  end

  set_jbuilder do
    Jbuilder.new do |json|
      json.key_format! camelize: :lower
      json.name name
      json.duration duration
    end
  end
end
