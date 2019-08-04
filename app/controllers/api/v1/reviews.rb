# To do:
# 1. Nokogiri will pull all reviews, even those hidden below the fold. Do I want to loop over pages?
# 2. Confirm this works for different types of lender (business, mortgage, etc.)
#   since they're given a unique url path
# 3. Investigate other available data
# 4. Refactor
#   a. Grape
# 5. Test
# 6. Documentation

module API
  module V1
    class Reviews < Grape::API
      helpers API::V1::Helpers::Reviews
      version 'v1', using: :path
      format :json
      prefix :api

      resource :reviews do
        desc 'Return reviews at a url'
        params do
          requires :base_url, type: String
          optional :page_count, type: Integer
        end
        get do
          reviews = []
          url = "#{params[:base_url]}"
          page = Nokogiri::HTML(open(url))
          reviews += page.css('div.mainReviews')
          review_payload(reviews)
        end
      end
    end
  end
end
