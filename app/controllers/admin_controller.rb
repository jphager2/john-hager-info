class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events

  around_action :log_exceptions
  before_action :authenticate_user

  private
  def authenticate_user
    redirect_to root_path unless signed_in?
  end

  def log_exceptions
    yield
  rescue Object => e
    puts "\n" * 3
    puts 'Error Caught in Admin Controller'
    puts e, e.message
    puts "\n" * 3
    raise
  end
end
