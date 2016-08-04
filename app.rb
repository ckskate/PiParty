require "sinatra/base"
require_relative "streamer"
require_relative "service"

class PiParty < Sinatra::Base

  @@streamer = Streamer.new
  @@service = Service.new({{ GOOGLE_API_CODE }})

  get '/' do
    "Hello World!"
  end

  get '/play' do
    @@streamer.play
  end

  get '/pause' do
    @@streamer.pause
    "toggled"
  end

  get '/stop' do
    @@streamer.stop
    "stopped"
  end

  get '/next' do
    @@streamer.next
  end

  get '/search' do
    @@streamer.stop
    if params[:q]
      @@streamer.update_tracks(@@service.search(params[:q]))
      @@streamer.play
    else
      "invalid search parameter"
    end
  end

end
