module RSGuitarTech
  class SavedGame
    module LearnASong

      DynamicDifficulty = Struct.new(:avg, :phrases, :level_up) do
        # Avg = one of [0.0, 1.0, 2.0, 3.0, 4.0]
        # Phrases = a whole big thing
        # LevelUp = array of tiny floats
      end

      PlaynextStats = Struct.new(:timestamp, :phrase_iterations, :chords, :articulations, :phrases) do
        # TimeStamp = duh
        # PhraseIterations
        # Chords
        # Articulations
        # Phrases
      end

      class Song
        attr_accessor :id, :timestamp, :dynamic_difficulty, :play_next_stats

        def self.from(key, json)
          self.new(
            id:                  key,
            timestamp:           json["TimeStamp"],
            dynamic_difficulty:  json["DynamicDifficulty"],
            play_next_stats:     json["PlaynextStats"]
          )
        end

        def initialize(id:, timestamp:, dynamic_difficulty:, play_next_stats:)
          @id                 = id
          @timestamp          = timestamp
          @dynamic_difficulty = dynamic_difficulty
          @play_next_stats    = play_next_stats
        end

        def ==(other)
          return false if other == nil

          id == other.id
        end
      end
    end
  end
end
