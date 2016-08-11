class Streamer
  include Process

  attr_reader :track_list

  def initialize
    @track_list = []
  end

  def play
    unless @process
      @thr = Thread.new do
        until @track_list.empty?
          track = @track_list.first
          @process = IO.popen("omxplayer -o both \"$(youtube-dl -g \"https://youtube.com/watch?v=#{track[:id]}\" | sed -n '2p')\"")
          #@process = IO.popen("mpv \"$(youtube-dl -g \"https://youtube.com/watch?v=#{track[:id]}\" | sed -n '2p')\"")
	  waitpid @process.pid
          @track_list.shift
        end
	stop
      end
    end
    @track_list.first
  end

  def send_command(cmd)
    File.open('pipe', 'w+') do |file|
      file.puts cmd
    end
  end

  def stop
    if @process
      @process = nil
      `killall omxplayer.bin`
    end
    @thr.exit if @thr
  end

  def next
    stop
    play if @track_list.shift
  end

  def update_queue(track)
    @track_list.push(track) if track
  end
end
