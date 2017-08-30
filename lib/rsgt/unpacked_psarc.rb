module RSGuitarTech
  class UnpackedPSARC

    def self.from_psarc(psarc, opts)
      raise ArgumentError, "A block is required" unless block_given?
      raise ArgumentError, "#{psarc} not found!" unless File.exist?(psarc)

      puts "Unpacking psarc to temporary location..."
      # Use pyrocksmith to unpack the file, and check that it worked..
      CommandRunner.run! ["pyrocksmith", "--unpack", psarc, "--no-crypto"]
      expected_extraction = File.basename psarc, ".*"
      raise ArgumentError unless File.exist?(expected_extraction + "/appid.appid")

      # Move it to a tmpdir, and yield
      Dir.mktmpdir do |dir|
        FileUtils.mv expected_extraction, dir
        yield self.new(psarc, dir, opts)
      end
    end

    attr_accessor :psarc, :tmpdir, :opts

    def initialize(psarc, tmpdir, opts)
      @psarc  = psarc
      @tmpdir = tmpdir
      @opts   = opts
    end

    def repack!
      puts "Repacking altered psarc..."
      CommandRunner.run! ["pyrocksmith", "--no-crypto", "--pack", "#{tmpdir}/#{expected_extraction}"]
      puts "Done! ✅"
    end

    def expected_extraction
      File.basename psarc, ".*"
    end

    def manifest(type)
      Dir.glob("#{tmpdir}/#{expected_extraction}/manifests/*/*.json").detect { |filename| filename.include? type.to_s }
    end

    def sng_bin(type)
      Dir.glob("#{tmpdir}/#{expected_extraction}/songs/bin/macos/*.sng").detect { |filename| filename.include? type.to_s }
    end

    def sng_xml
      Dir.glob("#{tmpdir}/#{expected_extraction}/songs/bin/macos/*.xml").first
    end

    def audio_track(track: :main)
      audio_tracks[track]
    end

    def ogg_track
      audio_tracks[:main].gsub ".wem", ".ogg"
    end

  private

    def audio_tracks
      @audio_tracks ||= begin
        both_wems = Dir.glob("#{tmpdir}/#{expected_extraction}/audio/mac/*.wem").sort_by { |wem| File.stat(wem).size }

        {
          main:    both_wems.last,
          preview: both_wems.first
        }
      end
    end
  end
end
