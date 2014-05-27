ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + '/../../config/environment'

$running = true
Signal.trap("TERM") do
  $running = false
end

while($running) do
  events = PagesController.new.load_github_activity
  time_to_sleep = 10 
  sleep(time_to_sleep)
end
