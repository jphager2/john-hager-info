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

          data = []
          events.each_with_index do |event, i|
            data << {}
            data[i]["type"] = event["type"].sub("Event", '').downcase
            case data[i]["type"]
            when /push/
              commit = event["payload"]["commits"].last
              data["message"] = commit["message"]
            when /issue/
              issue = event["payload"]["issue"]
              labels = issue['labels'].map {|label| label["name"]} 

              data[i]["message"] = ""   << 
                "##{issue['number']}: " <<
                "#{issue['title']}"     << 

              unless labels.empty?
                data[i]["message"] << "; labels: #{labels.join(', ')}"  
              end
            else
              commit = "#" 
              message = "" 
            end

            base = commit || issue
            data[i]["path"] = base["url"]
              .sub('//api','//www')
              .sub('/repos/','/')

            data[i]["time"] = DateTime
              .parse(event['created_at'])
              .strftime("On %a, %d %b at %I:%M%p")

            data[i]["name"] = event["repo"]["name"]

            ws
              .send(
                JSON.generate({events: data})
              )
          end
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
