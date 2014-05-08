module PagesHelper
  def load_github_activity 
    @events = JSON(
      open('https://api.github.com/users/jphager2/events/public').read
    )[0..4] 

  rescue Exception => error
    puts "Rescuing #{error}: #{error.message} and providing a BlackHole!!!"
    @events = BlackHole.new
  end

  class BlackHole
    def initialize(*args)
    end

    def method_missing(method, *args, &block)
      BlackHole.new
    end
  end
end

