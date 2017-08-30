require "spec_helper"

describe RSGuitarTech::UnpackedPSARC do
  let(:psarc)    { "foo_m.psarc" }
  let(:opts)     { {} }

  describe ".from_psarc" do
    it "requires a block" do
      expect {
        described_class.from_psarc psarc, opts
      }.to raise_error ArgumentError, "A block is required"
    end
  end

  describe "#repack!" do
  end

  describe "#expected_extraction" do
  end

  describe "#manifest" do
  end

  describe "#sng_bin" do
  end

  describe "#sng_xml" do
  end

  describe "#audio_track" do
  end

  describe "#ogg_track" do
  end
end
