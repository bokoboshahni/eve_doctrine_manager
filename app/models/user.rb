class User < ApplicationRecord
  devise :omniauthable, :timeoutable, :trackable

  def current_sign_in_ip; end
  def current_sign_in_ip=(_val); end
  def last_sign_in_ip; end
  def last_sign_in_ip=(_val); end

  def self.authenticate_from_sso!(character_id)
    esi = HTTPX.plugin(:persistent)
                    .plugin(:retries)
                    .with(origin: 'https://esi.evetech.net/latest/')
    esi.plugin(:compression) unless Rails.env.test?
    esi.plugin(:response_cache) unless Rails.env.test?

    resp = esi.get("characters/#{character_id}/")
    resp.raise_for_status

    character = JSON.parse(resp)
    alliance_id = character['alliance_id']
    corporation_id = character['corporation_id']
    name = character['name']

    user = find_by(character_id: character_id)
    if user
      user.update(alliance_id: alliance_id, corporation_id: corporation_id) if user
    else
      user = create(alliance_id: alliance_id, corporation_id: corporation_id, character_id: character_id, name: name) unless user
    end

    allowed =
      ENV.fetch('ALLOWED_CHARACTER_IDS', '').split(',').map(&:to_i).include?(character_id) ||
      ENV.fetch('ALLOWED_CORPORATION_IDS', '').split(',').map(&:to_i).include?(corporation_id) ||
      ENV.fetch('ALLOWED_ALLIANCE_IDS', '').split(',').map(&:to_i).include?(alliance_id)

    return user if allowed

    user.destroy
    nil
  end

  def avatar_url
    @avatar_url ||= "https://images.evetech.net/characters/#{character_id}/portrait"
  end
end
