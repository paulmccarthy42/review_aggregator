require 'rails_helper'

RSpec.describe API::V1::Helpers::Reviews do
  let(:endpoint) { Class.new { include API::V1::Helpers::Reviews }.new }
  let(:mocked_params) { {} }

  # before(:each) { allow(endpoint).to receive(:params) {mocked_params}}
  
  describe 'well_formed_request?' do

  end

  describe 'page_has_reviews?' do
    let(:page) { Nokogiri::HTML(open(url)) }
    let(:url) { Rails.root }

    context 'when page has no section with matching class' do
      let(:url) { "#{Rails.root}/spec/fixtures/random.html" }
      it 'returns false' do
        expect(endpoint.page_has_reviews?(page)).to be(false)
      end
    end

    context 'when page has section with matching class' do
      let(:url) { "#{Rails.root}/spec/fixtures/valid_page.html" }
      it 'returns true' do
        expect(endpoint.page_has_reviews?(page)).to be(true)
      end
    end

    context "when page has html element with matching class, but it's not a section" do
      let(:url) { "#{Rails.root}/spec/fixtures/wrong_html_element.html" }
      it 'returns false' do
        expect(endpoint.page_has_reviews?(page)).to be(false)
      end
    end
  end
end