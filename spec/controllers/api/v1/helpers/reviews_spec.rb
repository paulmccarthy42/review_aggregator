require 'rails_helper'
require_relative '../../../../fixtures/responses/example_data'

RSpec.describe API::V1::Helpers::Reviews do
  let(:endpoint) { Class.new { include API::V1::Helpers::Reviews }.new }
  let(:mocked_params) { {} }
  let(:page) { Nokogiri::HTML(open(url)) }
  let(:url) { "#{Rails.root}/spec/fixtures/pages/valid_page_no_reviews.html" }
  let(:reviews) { [] }

  # before(:each) { allow(endpoint).to receive(:params) {mocked_params}}
  
  describe 'well_formed_request?' do

  end

  describe 'page_has_reviews?' do
    context 'when page has section with matching class' do
      it 'returns true' do
        expect(endpoint.page_has_reviews?(page)).to be(true)
      end
    end

    context 'when page has no section with matching class' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/random.html" }
      it 'returns false' do
        expect(endpoint.page_has_reviews?(page)).to be(false)
      end
    end

    context "when page has html element with matching class, but it's not a section" do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/wrong_html_element.html" }
      it 'returns false' do
        expect(endpoint.page_has_reviews?(page)).to be(false)
      end
    end
  end

  describe 'payload' do
    it 'calls children payloads' do
      expect(endpoint).to receive(:lender_payload)
      expect(endpoint).to receive(:review_payload)
      endpoint.payload(reviews, page)
    end

    it 'returns hash of expected format' do
      allow(endpoint).to receive(:lender_payload).and_return('foo')
      allow(endpoint).to receive(:review_payload).and_return(reviews)
      expect(endpoint.payload(reviews, page)).to eq({
        lender: 'foo',
        reviews: []
      })
    end
  end

  describe 'lender_payload' do
    context 'when handling expected page format' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/valid_page.html" }
      it 'returns expected data in expected format' do
        expect(endpoint.lender_payload(page)).to eq({
          name: "First Midwest Bank",
          headline_numbers: {
            recommend_pct: 99,
            average_stars: 4.9,
            count_reviews: 1861,
            ratings_breakdown: {
              interest_rates_pct: 95.4,
              fees_and_closing_costs_pct: 93.2,
              responsiveness_pct: 98.6,
              customer_service_pct: 98.8
            }
          }
        })
      end
    end

    context 'when handling unexpected page format' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/random.html" }
      it 'returns default to empty data with expected format' do
        expect(endpoint.lender_payload(page)).to eq({
          name: "",
          headline_numbers: {
            recommend_pct: 0,
            average_stars: 0.0,
            count_reviews: 0,
            ratings_breakdown: {}
          }
        })
      end
    end
  end

  describe 'review_payload' do
    context 'when handling expected page format' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/valid_page.html" }
      let(:reviews) { page.css('div.mainReviews') }
      it 'returns expected data in expected format' do
        returned_reviews = endpoint.review_payload(reviews)
        expect(returned_reviews).to eq(ExampleData.expected_valid_data)
      end
    end

    context 'when no reviews present' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/random.html" }
      let(:reviews) { page.css('div.mainReviews') }
      it 'returns empty array' do
        expect(endpoint.review_payload(reviews)).to eq([])
      end
    end

    context 'when single empty review present' do
      let(:reviews) { page.css('div.mainReviews') }
      it 'returns empty array' do
        expect(endpoint.review_payload(reviews)).to eq(ExampleData.single_empty_review_data)
      end
    end

    # More time permitting, it's worth testing each datapoint in isolation
    # For now, showing this as a POC
    context 'when review present with some data' do
      let(:url) { "#{Rails.root}/spec/fixtures/pages/valid_page_partial_review.html" }
      let(:reviews) { page.css('div.mainReviews') }
      it 'returns empty array' do
        expect(endpoint.review_payload(reviews)).to eq(ExampleData.partial_review_data)
      end
    end
  end

  describe 'star_rating_to_int' do
    it 'handles expected format' do
      (0..5).each do |x|
        expect(endpoint.star_rating_to_int("(#{x} of 5)")).to eq(x)
      end  
    end

    it 'defaults to 0 on bad string submission' do
      expect(endpoint.star_rating_to_int("Random junk")).to eq(0)
    end 
  end
end