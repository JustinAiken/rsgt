module RSGuitarTech
  class WavShifter

    attr_accessor :wav, :dir, :amount

    def initialize(opts)
      @wav    = File.expand_path(opts.delete :wav)
      @dir    = opts[:dir]
      @amount = opts[:amount].to_i
    end

    def shift!
      case dir
      when "forward" then forward!
      when /back/    then backward!
      end
    end

  private

    def forward!
      raise NotImplementedError
    end

    def backward!
      Dir.mktmpdir do |tmpdir|
        puts "Trimming #{amount}ms from beginning..."
        status = CommandRunner.run! [
          "ffmpeg", "-i", wav,
          "-ss", start_trim_timestamp,
          "-acodec", "copy",
          "#{tmpdir}/shifted.wav"
        ]
        if status.success?
          puts "Success!"
          FileUtils.cp "#{tmpdir}/shifted.wav", wav
        else
          puts "Failed!"
        end
      end
    end

    TS_CONV = [1, 1000, 60000, 3600000]

    def start_trim_timestamp
      h  = (amount / TS_CONV[3])
      m  = (amount % TS_CONV[3] / TS_CONV[2])
      s  = (amount % TS_CONV[2] / TS_CONV[1])
      ms = (amount % TS_CONV[1])

      "%02d:%02d:%02d.%03d" % [h, m, s, ms]
    end
  end
end
