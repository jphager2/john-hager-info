# This file is used by Rack-based servers to start the application.
use Rack::ContentLength

require ::File.expand_path('../config/environment',  __FILE__)

Faye::WebSocket.load_adapter('thin')

run Rails.application
