require "spec_helper"

describe RSGuitarTech::WavShifter do
  let(:shifter) { described_class.new wav: "foo.wav", dir: direction, amount: 30 }
  let(:shift!)  { shifter.shift! }

  before { allow(shifter).to receive :puts }

  describe "convert!" do
    context "forward" do
      let(:direction) { "forward" }

      it "can't go forward" do
        expect { shift! }.to raise_error NotImplementedError
      end
    end

    context "backwards" do
      let(:direction) { "backward" }
      let(:status)    { double "status", success?: true }

      it "works" do
        expect(Dir).to receive(:mktmpdir).and_yield "foo_dir"
        expect(RSGuitarTech::CommandRunner).to receive(:run!).and_return status
        expect(FileUtils).to receive(:cp).with "foo_dir/shifted.wav", /foo\.wav/
        shift!
      end
    end
  end
end
