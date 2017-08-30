require "spec_helper"

describe RSGuitarTech::CommandRunner do
  let(:runner)        { described_class  }
  let(:args)          { "ls" }
  let(:skip_escaping) { false }
  subject(:run!)      { runner.run! args, skip_escaping: skip_escaping }

  it { should be_success }

  context "with spaces" do
    let(:args) { "ls -al" }

    after { run! }

    it "escapes the command" do
      expect(Open3).to receive(:capture3).with "ls\\ -al"
    end

    context "but skip_escaping: true" do
      let(:skip_escaping) { true }

      it "runs the command as-is" do
        expect(Open3).to receive(:capture3).with "ls -al"
      end
    end
  end

  context "verbosely" do
    before { allow(RSGuitarTech).to receive(:verbose).and_return true }

    it "does some puts" do
      expect_any_instance_of(described_class).to receive(:puts).at_least :once
      run!
    end
  end
end
