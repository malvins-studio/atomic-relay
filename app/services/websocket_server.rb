require "faye/websocket"
require "json"
require_relative "websocket_hub"

class WebsocketServer
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] == "/ws" && Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)
      device_id = nil

      ws.on :message do |event|
        data = JSON.parse(event.data)

        case data["type"]
        when "auth"
          if data["token"] == ENV["TOKEN_SECRET"]
            device_id = data["device_id"]
            WebSocketHub.register(device_id, ws)
            puts "Connected: #{device_id}"
          else
            ws.close
          end

        when "result"
          puts "Result: #{data}"
        end
      end

      ws.on :close do
        WebSocketHub.unregister(device_id) if device_id
        puts "Disconnected: #{device_id}"
      end

      return ws.rack_response
    end

    @app.call(env)
  end
end
