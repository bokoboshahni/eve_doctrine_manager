# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Doctrines' do
  describe 'GET #index' do
    it 'returns http success' do
      get doctrines_path
      expect(response).to have_http_status(:success)
    end
  end
end
