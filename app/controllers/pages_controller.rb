class PagesController < ApplicationController
  def index
    load_github_activity
  end

  def go
    load_github_activity
  end

  def contact
    load_github_activity
  end

  def cv
    load_github_activity
  end

  def portfolio
    @projects = Project.all
    load_github_activity
  end

  def admin
    load_github_activity
  end
end
