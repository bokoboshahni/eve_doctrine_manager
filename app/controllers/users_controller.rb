# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
end
