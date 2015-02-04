class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events
end
