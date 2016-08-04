class Streamer

  def play
    unless @process or not @track
      Thread.new do
        # raspbian
        # @process = IO.popen('omxplayer -o both "$(youtube-dl -g "https://youtube.com/watch?v=' + @track.id.video_id + '" | sed -n \'2p\')"')
        # macOS
        @process = IO.popen("mpv \"$(youtube-dl -g \"https://youtube.com/watch?v=#{@track[:id]}\" | sed -n '2p')\"")
      end
      "playing"
    end
    @track.inspect
  end

  def stop
    if @process
      Process.kill(0, @process.pid)
      @process = nil
    end
  end

  def update_tracks(tracks = @track_list)
    if tracks
      @track_list = tracks
      @track = @track_list.shift
    end
  end

end
