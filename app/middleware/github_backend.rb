require 'faye/websocket' 
require 'json'

module JohnHager
  class GithubBackend
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws

          events = PagesController.new.load_github_activity
            .map {|event| event.to_hash}

          ws.send(JSON.generate({events: events}))
        end
        
        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close, ws.object_id]
          ws = nil
        end

        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
