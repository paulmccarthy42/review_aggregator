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
        title: review.css('p.reviewTitle').inner_html,
        content: review.css('p.reviewText').inner_html,
        author: review.css('p.consumerName').children.first.to_s.strip,
        stars: review.css('div.numRec').inner_html,
        date: review.css('p.consumerReviewDate').inner_html
      }
    end
  end
end
