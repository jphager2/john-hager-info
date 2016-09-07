class PagesController < ApplicationController
  def index
    load_promotion
  end

  def contact
  end

  def cv
  end

  def portfolio
    @projects = Project.by_updated
  end
end
