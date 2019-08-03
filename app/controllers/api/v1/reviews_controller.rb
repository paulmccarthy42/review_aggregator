class Api::V1::ReviewsController < ApplicationController
  def index
    page = Nokogiri::HTML(open(review_params))
    render json: page.css('div.mainReviews')
  end

  private

  def review_params
    params.require(:url)
  end
end
