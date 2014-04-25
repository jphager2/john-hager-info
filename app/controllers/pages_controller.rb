class PagesController < ApplicationController
  def index
    @events = JSON(
      open('https://api.github.com/users/jphager2/events/public').read
    )[0..4] 
  end

  def go
  end

  def contact
  end

  def cv
  end

  def portfolio
  end
end
