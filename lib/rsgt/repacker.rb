module RSGuitarTech
  class Repacker

    attr_accessor :psarc, :opts, :unpacked

    def initialize(opts)
      @psarc = File.expand_path(opts.delete :psarc)
      @opts  = opts
    end

    def repack!
      UnpackedPSARC.from_psarc(psarc, opts) do |unpacked|
        repack_vocals(unpacked) if opts[:vocals_xml]
        repack_audio(unpacked)  if opts[:audio]
        unpacked.repack!
      end
    end

  private

    def repack_vocals(unpacked)
      puts ".. Converting .xml to .sng"
      CommandRunner.run! RSCustomSongToolkit.xml2sng(
        manifest: unpacked.manifest(:vocals),
        input:    opts[:vocals_xml]
      )
    end

    def repack_audio(unpacked)
      puts ".. Converting audio to .wem"
      WWiseConverter.new(opts[:audio], opts).convert! do |converter|
        FileUtils.cp converter.results[:main],    unpacked.audio_track
        FileUtils.cp converter.results[:preview], unpacked.audio_track(track: :preview) if opts[:preview]
      end
    end
  end
end
