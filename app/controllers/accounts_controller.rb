class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accounts, only:  [:show]

  def show
  end

  private

  def set_accounts
    if User.exists?(id: params[:id])
      @account = User.find params[:id]
    else
      redirect_to root_path, alert: 'User not found'
    end
  end
end
