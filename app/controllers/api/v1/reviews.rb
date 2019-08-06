# To do:
# 1. Test
# 3. Documentation
# 4. Refactor

module API
  module V1
    class Reviews < Grape::API
      BAD_FORMAT_ERROR = 'URL must match following format to properly return reviews: "https://www.lendingtree.com/reviews/:credit_type/:company_slug/:company_id"'.freeze
      NO_REVIEWS_ERROR = 'No reviews were found at this URL. Please visit URL manually to confirm that lender exists and page is valid'.freeze
      INTERNAL_SERVER_ERROR = 'Internal server error encountered processing request'.freeze

      helpers API::V1::Helpers::Reviews
      version 'v1', using: :path
      format :json
      prefix :api

      resource :reviews do
        desc 'Returns reviews from Lending Tree, based on url for reviews. User can also request multiple pages of reviews through page_count param'
        params do
          requires :base_url, type: String
          optional :page_count, type: Integer
        end
        get do
          begin
            error!({errors: BAD_FORMAT_ERROR}, 400) unless well_formed_request?
            first_page = Nokogiri::HTML(open(params[:base_url]))
            error!({errors: NO_REVIEWS_ERROR}, 500) unless page_has_reviews?(first_page)

            page_count = params[:page_count] || 1
            reviews = []
            i = 1
            while i <= page_count
              url = "#{params[:base_url]}?pid=#{i}"
              page = Nokogiri::HTML(open(url))
              new_reviews = page.css('div.mainReviews')
              break if new_reviews.empty?
              reviews += new_reviews
              i += 1
            end

            payload(reviews, first_page)
          rescue => e
            error!({error: INTERNAL_SERVER_ERROR, details: e}, 500)
          end
        end
      end
    end
  end
end
