class Streamer

  def initialize
    @track_list = []
  end

  def play
    unless @process or not @track_list
      @thr = Thread.new do
        @track_list.each do |track|
          # raspbian
          # @process = IO.popen('omxplayer -o both "$(youtube-dl -g "https://youtube.com/watch?v=' + @track[:id] + '" | sed -n \'2p\')"')
          # macOS
          @process = IO.popen("mpv \"$(youtube-dl -g \"https://youtube.com/watch?v=#{track[:id]}\" | sed -n '2p')\"")
          Process.waitpid(@process.pid)
        end
      end
    end
    @track_list.first.inspect
  end

  def pause
    File.open('pipe', 'w+') do |file|
      file.puts "pause"
    end
  end

  def stop
    if @process
      Process.kill('QUIT', @process.pid)
      @process = nil
    end
    @thr.exit if @thr
  end

  def next
    stop
    play if @track_list.shift
  end

  def update_tracks(tracks = @track_list)
    @track_list = tracks if tracks
  end

end
