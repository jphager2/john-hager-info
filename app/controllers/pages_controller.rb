class PagesController < ApplicationController
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
end
