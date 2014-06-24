module PagesHelper
  def load_github_activity 
    @events = JSON(
      open('https://api.github.com/users/jphager2/events/public').read
    )[0..4] 

  rescue Exception => error
    puts "Rescuing #{error}: #{error.message} and providing a BlackHole!!!"
    @events = BlackHole.new
  end

  def load_promotion
    @promotion = Project.where(
      created_at: (Date.today-7)..(Date.today+1)
    )
  end

  class BlackHole
    def initialize(*args)
    end

    def method_missing(method, *args, &block)
      BlackHole.new
    end
  end
end

