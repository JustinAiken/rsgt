module RSGuitarTech
  class AudioExtractor

    attr_accessor :psarc, :opts, :unpacked

    def initialize(opts)
      @psarc = File.expand_path(opts.delete :psarc)
      @opts  = opts
    end

    def extract!
      UnpackedPSARC.from_psarc(psarc, opts) do |unpacked|

        # Convert main track from wem to ogg:
        CommandRunner.run! RSCustomSongToolkit.ww2ogg(unpacked.audio_track)
        raise StandardError unless File.exist?(unpacked.ogg_track)

        # Revorb it so it doesn't sound bad...
        CommandRunner.run! RSCustomSongToolkit.revorb(unpacked.ogg_track)

        FileUtils.cp unpacked.ogg_track, "output.ogg"
      end
    end
  end
end
