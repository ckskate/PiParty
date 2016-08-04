#\ -p 6969

require "google/apis/youtube_v3"
require_relative 'app'

youtube = Google::Apis::YoutubeV3::YouTubeService.new

app = PiParty.new(youtube)

run app
