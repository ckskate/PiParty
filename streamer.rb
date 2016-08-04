class Streamer

  def play
    unless @process or not @track
      @thr = Thread.new do
        # raspbian
        # @process = IO.popen('omxplayer -o both "$(youtube-dl -g "https://youtube.com/watch?v=' + @track[:id] + '" | sed -n \'2p\')"')
        # macOS
        @process = IO.popen("mpv \"$(youtube-dl -g \"https://youtube.com/watch?v=#{@track[:id]}\" | sed -n '2p')\"")
        Process.waitpid(@process.pid)
        play_next_track
      end
      "playing"
    end
    @track.inspect
  end

  def stop
    Process.kill(0, @process.pid) if @process
    @thr.exit if @thr
    @process = nil
  end

  def update_tracks(tracks = @track_list)
    if tracks
      @track_list = tracks
      @track = @track_list.shift
    end
  end

  def play_next_track
    @process = nil
    update_tracks
    play
  end

end
