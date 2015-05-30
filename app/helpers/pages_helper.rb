module PagesHelper
  require 'naught'

  def load_github_activity 
    api_request_uri = 'https://api.github.com/users/jphager2/events/public'
    api_response = JSON(open(api_request_uri, read_timeout: 2).read)
    @events  = GithubEvents.generate(api_response[0..4]) 
  rescue Object => error
    STDERR.puts (
      "Rescuing #{error}: #{error.message} " + 
      "and providing a BlackHole!!!"
    )
    @events = [GithubEvents::NullEvent.new]   
  end

  def load_promotion
    @promotion = Project.where(
      created_at: (Date.today-7)..(Date.today+1)
    )
  end

  module GithubEvents

    def self.generate(events)
      events.map do |event|
        type = event['type'].sub('Event', '').downcase
        case type 
        when /push/  then Push.new(event)
        when /issue/ then Issue.new(event)
        else
          Event.new(event, type)
        end
      end
    end

    class Event

      def initialize(hash, type = nil)
        @hash = hash
        @action = type
      end

      def action 
        @action
      end

      def profile_img
        @hash["actor"]["avatar_url"]
      end

      def repo
        @hash['repo']['name'] 
      end

      def datetime 
        DateTime.parse(@hash['created_at'])
          .strftime("On %a, %d %b at %I:%M%p") 
      end

      def message
        ""
      end

      def item
        {'url' => '#'}
      end

      def uri
        @uri = item['url']          
        @uri.sub('//api','//www').sub('/repos/','/')
      end

      def to_hash
        {
          'profile_img' => profile_img,
          'message'     => message,
          'uri'         => uri,
          'action'      => action,
          'repo'        => repo,
          'datetime'    => datetime,
        }
      end
    end

    class Push < Event
      def action
        "pushed"
      end

      def item 
        @hash['payload']['commits'].last
      end

      def message
        item['message']
      end
    end

    class Issue < Event
      def action
        "submitted issue"
      end

      def item
        @hash['payload']['issue']
      end

      def message
        "##{item['number']} #{item['title']}#{labels}"
      end

      def labels
        labels = item['labels'].map {|label| label["name"]}
        "; labels: #{labels.join(', ')}" unless labels.empty?
      end
    end

    NullEvent = Naught.build do |config|
      config.mimic Event
      def message
        "Looks like the server didn't get a response from Github." +
        "Try refreshing your browser in a minute."
      end
    end
  end
end

