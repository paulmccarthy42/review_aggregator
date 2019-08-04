# To do:
# 1. Nokogiri will pull all reviews, even those hidden below the fold. Do I want to loop over pages?
# 2. Confirm this works for different types of lender (business, mortgage, etc.)
#   since they're given a unique url path
# 3. Investigate other available data
# 4. Refactor
#   a. Grape
# 5. Test
# 6. Documentation

class Api::V1::ReviewsController < ApplicationController
  def index
    i =1
    reviews = []
    p 'starting'
    while i < 5
      url = "#{review_params}?sort=cmV2aWV3c3VibWl0dGVkX2Rlc2M=&pid=#{i}"
      page = Nokogiri::HTML(open(url))
      reviews += page.css('div.mainReviews')
      i += 1
    end
    render json: presented_reviews(reviews)
  end

  private

  def review_params
    params.require(:base_url)
  end

  def presented_reviews(reviews)
    reviews.map do |review|
      {
        title: review.css('p.reviewTitle').inner_html,
        content: review.css('p.reviewText').inner_html,
        author: review.css('p.consumerName').children.first.to_s.strip,
        stars: to_int(review.css('div.numRec').inner_html),
        date: review.css('p.consumerReviewDate').inner_html
      }
    end
  end

  def to_int(stars)
    stars[/\d/].to_i
  end
end
