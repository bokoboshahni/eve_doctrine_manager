# frozen_string_literal: true

class FittingsController < ApplicationController
  def index
    @fittings = Fitting.includes(:container).order(:fitting_name)
  end

  def show
    @fitting = Fitting.find(params[:id])
  end
end
