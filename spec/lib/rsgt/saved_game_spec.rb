require "spec_helper"

describe RSGuitarTech::SavedGame do
  let(:saved_game) { described_class.new json, :filename }

  pending ".from"

  describe "#options" do
    subject    { saved_game.options }
    let(:json) { {"Options" => {"foo" => "bar"}} }
    it         { should eq "foo" => "bar" }
  end

  describe "#statistics" do
    subject    { saved_game.statistics }
    let(:json) { {"Stats" => {"foo" => "bar"}} }
    it         { should be_a RSGuitarTech::SavedGame::Statistics }
  end

  describe "#song_statistics" do
    subject(:song_statistics) { saved_game.song_statistics }
    let(:json)                { {"Stats" => {"Songs" => {"abc" => "songdata"}}} }
    it                        { should be_a RSGuitarTech::SavedGame::SongCollection }

    it "is a keyed collection of Statistics::Song's" do
      expect(song_statistics["abc"]).to be_a RSGuitarTech::SavedGame::Statistics::Song
    end
  end

  describe "#score_attack" do
    subject(:score_attack) { saved_game.score_attack }
    let(:json)                { {"SongsSA" => {"abc" => "songdata"}} }
    it                        { should be_a RSGuitarTech::SavedGame::SongCollection }

    it "is a keyed collection of Statistics::Song's" do
      expect(score_attack["abc"]).to be_a RSGuitarTech::SavedGame::ScoreAttack::Song
    end
  end

  describe "#learn_a_song" do
    subject(:learn_a_song) { saved_game.learn_a_song }
    let(:json)                { {"Songs" => {"abc" => "songdata"}} }
    it                        { should be_a RSGuitarTech::SavedGame::SongCollection }

    it "is a keyed collection of Statistics::Song's" do
      expect(learn_a_song["abc"]).to be_a RSGuitarTech::SavedGame::LearnASong::Song
    end
  end
end
