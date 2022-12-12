# frozen_string_literal: true

class FittingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager!, only: %i[new create edit update destroy]

  def index
    @fittings = Fitting.includes(:container).order(:fitting_name)
  end

  def show
    @fitting = Fitting.find(params[:id])
  end
end
