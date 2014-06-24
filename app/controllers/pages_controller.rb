class PagesController < ApplicationController
  def initialize
    super
    load_github_activity
  end

  def index
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
