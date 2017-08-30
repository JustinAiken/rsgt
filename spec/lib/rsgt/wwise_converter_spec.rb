require "spec_helper"

describe RSGuitarTech::WWiseConverter do
  let(:converter)   { described_class.new source_file, opts }
  let(:source_file) { "foo.wav" }
  let(:opts)        { {wwise_ver: wwise_ver, quality: quality, chorus: chorus} }
  let(:wwise_ver)   { "2017" }
  let(:quality)     { "3" }
  let(:chorus)      { "30" }

  describe "convert!" do
    it "blahs" do
      expect(Dir).to receive(:mktmpdir).and_yield "foo_dir"
      expect(RSGuitarTech::CommandRunner).to receive(:run!).at_least :once
      expect(FileUtils).to receive(:cp).with "foo.wav", "foo_dir/Template/Originals/SFX/Audio.wav"

      converter.convert! do |hi|
        expect(hi.source_file).to eq "foo.wav"
      end
    end
  end
end
