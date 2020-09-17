# frozen_string_literal: true

module DomainEntities
  class Spectacle
    include Tainbox

    attribute :name, String
    attribute :duration
  end
end

