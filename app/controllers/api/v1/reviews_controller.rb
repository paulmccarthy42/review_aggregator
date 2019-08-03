class Api::V1::ReviewsController < ApplicationController
  def index
    render json: review_params
  end

  private

  def review_params
    params.require(:url)
  end
end
