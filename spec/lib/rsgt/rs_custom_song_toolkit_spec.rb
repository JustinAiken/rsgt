require "spec_helper"

describe RSGuitarTech::RSCustomSongToolkit do
  let(:rs_custom) { described_class  }

  it ".ww2ogg" do
    expect(rs_custom.ww2ogg "foo.wem").to eq [
      "wine",
      "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/ww2ogg.exe",
      "foo.wem",
      "--pcb",
      described_class::PCB_PATH
    ]
  end

  it ".revorb" do
    expect(rs_custom.revorb "foo.ogg").to eq [
      "wine",
      "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/revorb.exe",
      "foo.ogg"
    ]
  end

  it ".sng2xml" do
    expect(rs_custom.sng2xml manifest: "manifest.json", input: "foo.sng").to eq [
      "wine",
      "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/sng2014.exe",
      "--sng2xml",
      "--manifest=manifest.json",
      "--input=foo.sng",
      "--arrangement=Vocal",
      "--platform=Mac"
    ]
  end

  it ".xml2sng" do
    expect(rs_custom.xml2sng manifest: "manifest.json", input: "foo.xml").to eq [
      "wine",
      "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/sng2014.exe",
      "--xml2sng",
      "--manifest=manifest.json",
      "--input=foo.xml",
      "--arrangement=Vocal",
      "--platform=Mac"
    ]
  end
end
