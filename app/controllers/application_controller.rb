class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    @current_user ||= Account.where(id: session[:account_id]).first
  end

  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def set_current_user(account)
    session[:account_id] = account.id
  end
end
