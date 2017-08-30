module RSGuitarTech
  class SavedGame

    attr_accessor :json, :filename

    def self.from(filename)
      file    = File.open filename
      profile = RSGuitarTech::EncryptedSteamFile.read(file)
      self.new(profile.uncompressed_json, filename)
    end

    def initialize(json, filename)
      @json     = json
      @filename = filename
    end

    def options
      json["Options"]
    end

    def statistics
      @statistics ||= Statistics.new(json["Stats"])
    end

    def song_statistics
      @song_statistics ||= SongCollection.new(Statistics, json["Stats"]["Songs"])
    end

    def score_attack
      @score_attack ||= SongCollection.new(ScoreAttack, json["SongsSA"])
    end

    def learn_a_song
      @learn_a_song ||= SongCollection.new(LearnASong, json["Songs"])
    end
  end
end
