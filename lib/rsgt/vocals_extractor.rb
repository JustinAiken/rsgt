module RSGuitarTech
  class VocalsExtractor

    attr_accessor :psarc, :opts, :unpacked

    def initialize(opts)
      @psarc = File.expand_path(opts.delete :psarc)
      @opts  = opts
    end

    def extract!
      puts ".. Extracting vocals from sng to xml..."
      UnpackedPSARC.from_psarc(psarc, opts) do |unpacked|
        CommandRunner.run! RSCustomSongToolkit.sng2xml(
          manifest: unpacked.manifest(:vocals),
          input:    unpacked.sng_bin(:vocals)
        )
        raise StandardError, "Failed to extract vocals" unless File.exist? unpacked.sng_xml

        FileUtils.cp unpacked.sng_xml, "."
      end
    end
  end
end
