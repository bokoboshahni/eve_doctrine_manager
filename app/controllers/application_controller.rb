# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?

  private

  helper_method :user_logged_in?
  alias user_logged_in? user_signed_in?

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  def authorize_admin!
    not_found unless current_user.admin?
  end

  def authorize_manager!
    not_found unless current_user.manager?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
