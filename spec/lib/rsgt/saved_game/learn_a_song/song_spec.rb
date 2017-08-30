require "spec_helper"

describe RSGuitarTech::SavedGame::LearnASong::Song do
  pending ".from"

  describe "#==" do
    subject      { described_class.new id: "123", timestamp: nil, dynamic_difficulty: nil, play_next_stats: nil }
    let(:song_b) { described_class.new id: "123", timestamp: nil, dynamic_difficulty: nil, play_next_stats: nil }
    let(:song_c) { described_class.new id: "456", timestamp: nil, dynamic_difficulty: nil, play_next_stats: nil }

    it { should eq     song_b }
    it { should_not eq song_c }
    it { should_not eq nil }
  end
end
