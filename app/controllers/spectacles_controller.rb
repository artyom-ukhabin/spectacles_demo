# frozen_string_literal: true

class SpectaclesController < ApplicationController
  def index
    spectacles = spectacle_repo.schedule
    old, actual = spectacles.partition { |x| x.duration.first < Date.today }

    decorated_spectacles = {
      old: spectacle_decorator.decorate_collection(old),
      actual: spectacle_decorator.decorate_collection(actual)
    }
    render json: decorated_spectacles.to_json

  rescue StandardError => error
    render json: { error: error }, status: 500
  end

  def create
    result, payload = spectacle_scheduler.arrange_spectacle(
      params[:name],
      params[:start_date],
      params[:end_date],
    )

    if result == :success
      decorated_spectacle = spectacle_decorator.decorate(payload)
      render json: decorated_spectacle.serialize
    elsif result == :error
      render json: { error: payload }, status: 422
    end

  rescue StandardError => error
    render json: { error: error }, status: 500
  end

  def destroy
    spectacle_repo.destroy(params[:id])
    render json: "Success!".to_json, status: 200
  rescue StandardError => error
    render json: { error: error }, status: 500
  end

  private

  def spectacle_repo
    @spectacle_repo ||= DomainRepositories::Spectacle.new(Spectacle)
  end

  def spectacle_decorator
    SpectacleDecorator
  end

  def spectacle_scheduler
    @spectacle_scheduler ||= DomainServices::SpectacleScheduler.new(spectacle_repo)
  end
end