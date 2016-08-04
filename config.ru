#\ -p 6969

require "google/apis/youtube_v3"
require_relative 'app'

youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.key = 'AIzaSyCXrjoUfz7N5zY27c8PpDHVNk1SHm2vicM'

app = PiStream.new(youtube)

run app
