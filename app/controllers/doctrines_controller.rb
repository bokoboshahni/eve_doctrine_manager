# frozen_string_literal: true

class DoctrinesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!, only: %i[new create edit update destroy]
end
