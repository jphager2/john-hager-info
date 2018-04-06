class ApplicationController < ActionController::Base
  include SessionsHelper
  include PagesHelper

  protect_from_forgery with: :exception

  before_action :load_github_activity
end
