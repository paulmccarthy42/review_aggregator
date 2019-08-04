# To do:
# 2. Confirm this works for different types of lender (business, mortgage, etc.)
#   since they're given a unique url path
# 3. Investigate other available data
# 4. Refactor
#   a. CORS?
# 5. Test
# 6. Documentation
# 7. Error handling

module API
  module V1
    class Reviews < Grape::API
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
          page_count = params[:page_count] || 1
          reviews = []
          i = 1

          while i <= page_count
            url = "#{params[:base_url]}?pid=#{i}"
            page = Nokogiri::HTML(open(url))
            reviews += page.css('div.mainReviews')
            i += 1
          end

          review_payload(reviews)
        end
      end
    end
  end
end
