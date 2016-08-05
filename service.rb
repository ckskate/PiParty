require "google/apis/youtube_v3"

class Service

  def initialize(key)
    @youtube_service = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube_service.key = key
  end

  def search(term)
    sanitize @youtube_service.list_searches('snippet', q: term).items
  end

  # reject bad results and store in a more useful format.
  def sanitize(raw_results)
    raw_results.reject do |result|
      result.kind != "youtube#video"
    end
    list = raw_results.map do |result|
      { title: result.snippet.title,
        image: result.snippet.thumbnails.high.url,
        id:    result.id.video_id }
    end
    # only return top result (for queue).
    list.first
  end
end
