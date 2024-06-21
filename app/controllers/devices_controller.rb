class DevicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @devices = current_user.devices.order(created_at: :desc)
  end

  def show
    @device = current_user.devices.find(params[:id])
  end
end
