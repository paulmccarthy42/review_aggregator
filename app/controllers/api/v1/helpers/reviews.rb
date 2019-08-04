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

  def well_formed_request?
    url_sections = params[:base_url].split('/')
    url_sections.count == 7 &&
      url_sections[0..3] == ['https:', '', 'www.lendingtree.com', 'reviews'] &&
      url_sections[6].to_i.to_s == url_sections[6]
  end

  def url_has_reviews?(url)
    !Nokogiri::HTML(open(url)).css('section.lenderReviews').empty?
  end

  private

  def to_int(stars)
    stars[/\d/].to_i
  end
end