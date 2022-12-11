# frozen_string_literal: true

module ItemsHelper
  EVE_IMAGE_SERVER_URL = 'https://images.evetech.net/types'

  def item_icon_url(item)
    "#{EVE_IMAGE_SERVER_URL}/#{item.id}/icon"
  end

  def item_render_url(item)
    "#{EVE_IMAGE_SERVER_URL}/#{item.id}/render"
  end
end
