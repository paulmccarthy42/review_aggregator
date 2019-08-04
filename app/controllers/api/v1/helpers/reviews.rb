module API::V1::Helpers::Reviews
  def review_payload(reviews)
    reviews.map do |review|
      {
        title: review.css('p.reviewTitle').inner_html,
        content: review.css('p.reviewText').inner_html,
        author: review.css('p.consumerName').children.first.to_s.strip,
        stars: to_int(review.css('div.numRec').inner_html),
        date: review.css('p.consumerReviewDate').inner_html.sub('Reviewed in ', '')
      }
    end
  end

  private

  def to_int(stars)
    stars[/\d/].to_i
  end
end