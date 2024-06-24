class AccountsController < ApplicationController
  def new
  end

  def create
    account_service = Mi::Service::Account.new(params[:user_id], params[:password], debug: true)
    account_service.login("xiaomiio") rescue binding.irb
    if account_service.success?
      account_service.login_all
      account = Account.where(user_id: params[:user_id]).first
      if account.nil?
        account = Account.create(
          user_id: params[:user_id],
          password: params[:password],
          authenticated_data: account_service.info
        )
      else
        account.update(
          password: params[:password],
          authenticated_data: account_service.info
        )
      end
      account.create_devices_from_service(Mi::Service::Mina.new(account_service, debug: true).device_list)
      set_current_user(account)
      redirect_to devices_path
    else
    end
  end
end
