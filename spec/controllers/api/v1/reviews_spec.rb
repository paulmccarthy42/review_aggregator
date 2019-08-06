require 'rails_helper'
require_relative '../../../fixtures/responses/example_data'

RSpec.describe API::V1::Reviews, type: :request do
  describe 'GET /api/v1/reviews' do
    let!(:path) { '/api/v1/reviews' }
    let(:params) { {base_url: "#{Rails.root}/spec/fixtures/pages/valid_page.html"} }

    context 'when testing production specific logic' do
      before(:each) { allow(Rails).to receive(:env).and_return 'production'}
      it 'returns an error if url is poorly formed' do
        params[:base_url] = "random"
        get path, params: params
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to eq ({"errors" => described_class::BAD_FORMAT_ERROR})
      end

      it 'returns an error if no base_url provided' do
        params = nil
        get path, params: params
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to eq ({"error" => "base_url is missing"})
      end
    end

    context 'when testing on local fixtures' do
      before(:each) { allow(Rails).to receive(:env).and_return 'test'}
      it 'returns an error if no base_url provided' do
        params = nil
        get path, params: params
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to eq ({"error" => "base_url is missing"})
      end

      it 'returns an error if non-integer page_count provided' do
        params[:page_count] = "floop"
        get path, params: params
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to eq ({"error" => "page_count is invalid"})
      end

      it 'returns no reviews error if page has no reviews container' do
        params[:base_url] = "#{Rails.root}/spec/fixtures/pages/random.html"
        get path, params: params
        expect(response.status).to eq 500
        expect(JSON.parse(response.body)).to eq ({"errors" => described_class::NO_REVIEWS_ERROR})
      end

      it 'returns expected data when endpoint accessed with valid URL' do
        get path, params: params
        expect(response.status).to eq 200
        expect(JSON.parse(response.body, {:symbolize_names => true})).to eq (
        {
          lender: ExampleData.expected_valid_lender_data,
          reviews: ExampleData.expected_valid_review_data
        })
      end

      context 'when page_count submitted' do
        it 'loads valid reviews from multiple pages' do
          params[:page_count] = 3

          get path, params: params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body, {:symbolize_names => true})).to eq (
          {
            lender: ExampleData.expected_valid_lender_data,
            reviews: ExampleData.expected_valid_review_data + ExampleData.partial_review_data + ExampleData.partial_review_data
          })
        end

        it 'does not loads valid reviews past requested page count' do
          params[:page_count] = 2

          get path, params: params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body, {:symbolize_names => true})).to eq (
          {
            lender: ExampleData.expected_valid_lender_data,
            reviews: ExampleData.expected_valid_review_data + ExampleData.partial_review_data
          })
        end

        it 'stops making web requests once it hits a page with no reviews' do
          params[:page_count] = 5

          get path, params: params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body, {:symbolize_names => true})).to eq (
          {
            lender: ExampleData.expected_valid_lender_data,
            reviews: ExampleData.expected_valid_review_data + ExampleData.partial_review_data + ExampleData.partial_review_data
          })
        end
      end
    end
  end
end