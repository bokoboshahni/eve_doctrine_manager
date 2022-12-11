# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ItemsHelper. For example:
#
# describe ItemsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ItemsHelper do
  let(:item) { instance_double(Item, id: 1) }

  describe '#item_icon_url' do
    it 'returns the image server icon URL for the item' do
      expect(helper.item_icon_url(item)).to eq('https://images.evetech.net/types/1/icon')
    end
  end

  describe '#item_render_url' do
    it 'returns the image server icon URL for the item' do
      expect(helper.item_render_url(item)).to eq('https://images.evetech.net/types/1/render')
    end
  end
end
