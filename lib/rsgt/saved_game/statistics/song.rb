module RSGuitarTech
  class SavedGame
    class Statistics

      class Song
        ATTRIBUTES = *%i{
          id date_sa sa_platinum_point_awarded mastery_last sa_play_count played_count accuracy_global date_las accuracy_chords
          mastery_previous mastery_peak mastery_previous_peak streak sa_win_count sa_general_point_awarded articulation_accuracy
          chords_accuracies sa_fail_count score_attack_play_count
        }

        attr_accessor *ATTRIBUTES

        def self.from(key, json)
          sa_play_count = json["SAPlayCount"].map(&:values).flatten rescue []
          self.new(
            id:                        key,
            date_sa:                   json["DateSA"],
            sa_platinum_point_awarded: json["SAPlatinumPointAwarded"],
            mastery_last:              json["MasteryLast"],
            sa_play_count:             sa_play_count,
            played_count:              json["PlayedCount"],
            accuracy_global:           json["AccuracyGlobal"],
            date_las:                  json["DateLAS"],
            accuracy_chords:           json["AccuracyChords"],
            mastery_previous:          json["MasteryPrevious"],
            mastery_peak:              json["MasteryPeak"],
            mastery_previous_peak:     json["MasteryPreviousPeak"],
            streak:                    json["Streak"],
            sa_win_count:              json["SAWinCount"],
            sa_general_point_awarded:  json["SAGeneralPointAwarded"],
            articulation_accuracy:     json["ArticulationAccuracy"],
            chords_accuracies:         json["ChordsAccuracies"],
            sa_fail_count:             json["SAFailCount"],
            score_attack_play_count:   json["ScoreAttack_PlayCount"]
          )
        end

        def self.nil_song
          self.new(
            ATTRIBUTES.inject({}) { |memo, attr| memo[attr] = nil; memo }
          )
        end

        def initialize(args)
          args.each do |k, v|
            self.send("#{k}=", v)
          end
        end

        def ==(other)
          return false if other == nil
          id == other.id
        end
      end
    end
  end
end
