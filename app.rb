require "sinatra/base"
require "json"
require_relative "streamer"
require_relative "service"

class PiParty < Sinatra::Base

  @@streamer = Streamer.new
  @@service = Service.new('AIzaSyCXrjoUfz7N5zY27c8PpDHVNk1SHm2vicM')

  set :bind, '0.0.0.0'

  get '/play' do
    @@streamer.play.to_json
  end

  get '/pause' do
    @@streamer.send_command "p"
    "toggled"
  end

  get '/vol/+' do
    @@streamer.send_command "="
    "vol up"
  end

  get '/vol/-' do
    @@streamer.send_command "-"
    "vol down"
  end

  get '/stop' do
    @@streamer.stop
    "stopped"
  end

  get '/next' do
    @@streamer.next.to_json
  end

  get '/queue' do
    return @@streamer.track_list.to_json
  end

  get '/queue/add' do
    if params[:q]
      res = @@service.search(params[:q])
      @@streamer.update_queue(res)
      @@streamer.play
      return res.to_json
    else
      "invalid search parameter"
    end
  end
end
