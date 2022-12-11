# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fittings' do
  describe 'GET #index' do
    it 'returns http success' do
      get fittings_path
      expect(response).to have_http_status(:success)
    end
  end
end
