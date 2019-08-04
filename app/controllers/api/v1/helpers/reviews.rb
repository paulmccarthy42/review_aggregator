module API::V1::Helpers::Reviews
  def well_formed_request?
    url_sections = params[:base_url].split('/')
    url_sections.count == 7 &&
      url_sections[0..3] == ['https:', '', 'www.lendingtree.com', 'reviews'] &&
      url_sections[6].to_i.to_s == url_sections[6]
  end

  def url_has_reviews?(url)
    !Nokogiri::HTML(open(url)).css('section.lenderReviews').empty?
  end

  def review_payload(reviews)
    reviews.map do |review|
      {
        title: review.css('p.reviewTitle').inner_html,
        content: review.css('p.reviewText').inner_html,
        author: review.css('p.consumerName').children.first.to_s.strip,
        stars: to_int(review.css('div.numRec').inner_html),
        recommended: review.css('div.lenderRec').present?,
        date: review.css('p.consumerReviewDate').inner_html.sub('Reviewed in ', ''),
        review_points: review_points(review)
      }
    end
  end

  def to_int(stars)
    stars[/\d/].to_i
  end

  # these "Review points" appear to vary between lending categories, which is why I'm making
  # this section of the payload more flexible. If this data were variable enough to justify it,
  # I'd consider storing this piece as a json in any database store.
  def review_points(review)
    review.css('div.reviewPoints > div > ul > li').reduce({}) do |json, point|
      json.merge({point.css('p').inner_html => point.css('div').inner_html})
    end
  end
end