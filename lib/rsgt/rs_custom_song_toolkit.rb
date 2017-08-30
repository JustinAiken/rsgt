module RSGuitarTech
  class RSCustomSongToolkit

    PCB_PATH = "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/packed_codebooks_aoTuV_603.bin"

    def self.ww2ogg(file)
      base_cmd "ww2ogg", [file, "--pcb", PCB_PATH]
    end

    def self.revorb(file)
      base_cmd "revorb", [file]
    end

    def self.sng2xml(manifest:, input:)
      sng2014 "--sng2xml", manifest: manifest, input: input
    end

    def self.xml2sng(manifest:, input:)
      sng2014 "--xml2sng", manifest: manifest, input: input
    end

  private

    def self.sng2014(cmd, manifest:, input:, arrangement: "Vocal", platform: "Mac")
      base_cmd "sng2014", [
        cmd,
        "--manifest=#{manifest}",
        "--input=#{input}",
        "--arrangement=#{arrangement}",
        "--platform=#{platform}"
      ]
    end

    def self.base_cmd(tool, args)
      [
        "wine",
        "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/#{tool}.exe"
      ] + args
    end
  end
end
