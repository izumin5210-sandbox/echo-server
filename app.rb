require 'bundler'
Bundler.require

set :server, 'thin'
set :sockets, []

get '/' do
  if !request.websocket?
    settings.sockets.each { |ws| ws.send(params[:color]) }
    status 204
    body ''
  else
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end
