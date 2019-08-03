class Api::V1::ReviewsController < ApplicationController
  def index
    page = Nokogiri::HTML(open(review_params))
    reviews = page.css('div.mainReviews')
    render json: presented_reviews(reviews)
  end

  private

  def review_params
    params.require(:url)
  end

  def presented_reviews(reviews)
    reviews.map do |review|
      {
        title: review.css('p.reviewTitle').inner_html
      }
    end
  end
end
