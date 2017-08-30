require "spec_helper"

describe RSGuitarTech::AudioExtractor do
  let(:extractor) { described_class.new psarc: psarc }
  let(:psarc)     { "foo_m.psarc" }

  describe "#extract!" do
    it "extracts" do
      allow(extractor).to receive :puts
      expect(RSGuitarTech::UnpackedPSARC).to receive :from_psarc
      extractor.extract!
    end
  end
end
