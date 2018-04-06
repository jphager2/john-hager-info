class AdminController < ApplicationController
  layout 'admin'

  skip_before_action :load_github_activity

  before_action :authenticate_user

  protected

  def authenticate_user
    redirect_to root_path unless signed_in?
  end
end
