require "spec_helper"

describe RSGuitarTech::Repacker do
  let(:repacker)   { described_class.new psarc: "foo_m.psarc", vocals_xml: vocals_xml, audio: audio }
  let(:vocals_xml) { "foo_vocals.xml" }
  let(:audio)      { "audio.wav" }

  let(:unpacked)  { double RSGuitarTech::UnpackedPSARC, manifest: "manifest.json", audio_track: "track.wem" }
  let(:converter) { double RSGuitarTech::WWiseConverter, results: {main: "main.wav"} }

  describe "#repack!" do
    before { allow(repacker).to receive :puts }

    it "repacks" do
      expect(RSGuitarTech::UnpackedPSARC).to receive(:from_psarc).and_yield unpacked
      expect_any_instance_of(RSGuitarTech::WWiseConverter).to receive(:convert!).and_yield converter
      expect(FileUtils).to receive(:cp).with "main.wav", "track.wem"
      expect(RSGuitarTech::CommandRunner).to receive :run!
      expect(unpacked).to receive :repack!

      repacker.repack!
    end
  end
end
