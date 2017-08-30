module RSGuitarTech
  class SavedGame
    module ScoreAttack

      PICKS = {
        2.0 => "Bronze",
        3.0 => "Silver",
        4.0 => "Gold",
        5.0 => "Platinum",
      }

      DIFFICULTIES = %w{Easy Medium Hard Master}

      class Song
        attr_accessor :id, :timestamp, :play_count, :picks, :high_scores

        def self.from(key, json)
          self.new(
            id:          key,
            timestamp:   json["TimeStamp"],
            play_count:  json["PlayCount"],
            picks:       json["Badges"],
            high_scores: json["HighScores"],
          )
        end

        def initialize(id:, timestamp:, play_count:, picks:, high_scores:)
          @id, @timestamp, @play_count, @picks, @high_scores = id, timestamp, play_count, picks, high_scores
        end

        def ==(other)
          return false if other == nil
          id == other.id
        end
      end
    end
  end
end
