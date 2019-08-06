module API::V1::Helpers::Reviews

  # confirms that 
  # 1. url begins with https://www.lendingtree.com/reviews/ (https is necessary for nokogiri to function)
  # 2. url route can be converted to https://www.lendingtree.com/reviews/:credit_type/:company_slug/:company_id
  # 3. the last part of the url is wholly an integer, since extra query params 
  #  at the end of the url could affect the multiple page loading function
  def well_formed_request?
    url_sections = params[:base_url].split('/')
    url_sections[0..3] == ['https:', '', 'www.lendingtree.com', 'reviews'] &&
      url_sections.count == 7 &&
      url_sections[6].to_i.to_s == url_sections[6]
  end

  def page_has_reviews?(first_page)
    !first_page.css('section.lenderReviews').empty?
  end

  def payload(reviews, page)
    {
      lender: lender_payload(page),
      reviews: review_payload(reviews)
    }
  end

  def lender_payload(page)
    {
      name: page.css('div.lenderInfo > h1').inner_html,
      headline_numbers: {
        recommend_pct: recommended_pct(page),
        average_stars: star_rating_to_int(page.css('div.start-rating-reviews > span.hidden-xs').inner_html),
        count_reviews: page.css('a.reviews-count').inner_html.gsub(/\D/, '').to_i,
        ratings_breakdown: ratings_breakdown_payload(page)
      }
    }
  end

  def review_payload(reviews)
    reviews.map do |review|
      {
        title: review.css('p.reviewTitle').inner_html,
        content: review.css('p.reviewText').inner_html,
        author: review.css('p.consumerName').children.first.to_s.strip,
        stars: star_rating_to_int(review.css('div.numRec').inner_html),
        recommended: review.css('div.lenderRec').present?,
        date: review.css('p.consumerReviewDate').inner_html.sub('Reviewed in ', ''),
        review_points: review_points_payload(review)
      }
    end
  end

  def ratings_breakdown_payload(page)
    page.css('ul.rating-bar-section').first.css('li').reduce({}) do |ratings, rating_category|
      ratings.merge(
        {
          (rating_category.css('label').inner_html.parameterize(separator: '_').sub('_amp_', '_and_') + '_pct').to_sym =>
          rating_category.css('div.rating-bar-top').first[:style].gsub(/[^\d\.]/, '').to_f
        }
      )
    end
  rescue => e
    # rollbar error
    {}
  end

  # these "Review points" appear to vary between lending categories, which is why I'm making
  # this section of the payload more flexible. If this data were variable enough to justify it,
  # I'd consider storing this piece as a json in any database store.
  def review_points_payload(review)
    review.css('div.reviewPoints > div > ul > li').reduce({}) do |json, point|
      json.merge({point.css('p').inner_html.parameterize(separator: '_').to_sym => point.css('div').inner_html})
    end
  end

  def star_rating_to_int(stars)
    star_count = stars.gsub(/[()]/, '').split(' of').first
    # In production, this logic would likely contain a call to an error reporting service
    # like Rollbar if star_count had a non number in it.
    # That sort of error reporting would likely be implemented throughout most of the functions outlined here.
    star_count.to_f
  end

  def recommended_pct(page)
    page.css('div.recommend-text > span').first.inner_html.gsub(/\D/, '').to_i
  rescue => e
    # rollbar error
    0
  end
end