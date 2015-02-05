class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events
  before_action :authenticate_user

  private
  def authenticate_user
    redirect_to root_path unless signed_in?
  end
end
