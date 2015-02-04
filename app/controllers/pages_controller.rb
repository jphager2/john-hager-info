class PagesController < ApplicationController
  skip_before_action :load_github_activity, only: [:admin]
  layout 'admin', only: [:admin]

  def index
    load_promotion
  end

  def go
  end

  def contact
  end

  def cv
  end

  def portfolio
    @projects = Project.order("updated_at desc")
  end

  def admin
    redirect_to root_path unless signed_in?
    @projects = Project.all
  end
end
