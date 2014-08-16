module PagesHelper
  def load_github_activity 
    api_request_uri = 'https://api.github.com/users/jphager2/events/public'
    json = open(api_request_uri).read
    @events = JSON(json)[0..4].map { |event| GithubEvent.new(event) } 
  rescue Exception => error
    puts "Rescuing #{error}: #{error.message} and providing a BlackHole!!!"
    @events = BlackHole.new
  end

  def load_promotion
    @promotion = Project.where(
      created_at: (Date.today-7)..(Date.today+1)
    )
  end

  class GithubEvent

    def initialize(hash)
      @hash = hash
    end

    def datetime 
      @datetime ||= hash['created_at']).strftime("On %a, %d %b at %I:%M%p") 
    end

    def message
      @message ||= ""
    end

    def uri
      @uri ||= "#"
    end
  end

  class BlackHole
    def initialize(*args)
    end

    def method_missing(method, *args, &block)
      BlackHole.new
    end
  end
end

