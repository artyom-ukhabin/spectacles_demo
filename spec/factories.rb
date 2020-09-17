# frozen_string_literal: true

FactoryBot.define do
  factory :spectacle do
    sequence(:name) { |n| "name_#{n}" }
    duration { Date.current - 1.day..Date.current + 1.day }
  end
end