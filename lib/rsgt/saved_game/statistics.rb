module RSGuitarTech
  class SavedGame
    class Statistics

      attr_accessor :json

      def initialize(json)
        @json = json
      end

      # Timing Section
      def session_seconds
        json['SessionTime']
      end

      def las_seconds
        json['TimePlayed']
      end

      def games_seconds
        json['GuitarcadePlayedTime'].map(&:values).flatten.inject(&:+)
      end

      def lesson_second
        json['TimePlayedAndLesson'] - las_seconds
      end

      def rs_seconds
        session_seconds + las_seconds + games_seconds + lesson_second
      end

      # / Timing Section

      def missions_completed
        json['TotalNumMissionCompletions'].to_i
      end

      def session_count
        json['SessionCnt'].to_i
      end

      def songs_played_count
        json['SongsPlayedCount'].to_i
      end

      def songs_mastered_count
        json['NumSongsMastered'].to_i
      end

      def dlc_played_count
        json['DLCPlayedCount'].to_i
      end

      def songs_lead_played_count
        json['SongsLeadPlayedCount'].to_i
      end

      def songs_rhythm_played_count
        json['SongsRhythmPlayedCount'].to_i
      end

      def songs_bass_played_count
        json['SongsBassPlayedCount'].to_i
      end

      def session_mission_time
        json['SessionMissionTime']
      end

      def longest_streak
        json['Streak'].to_i
      end

      def sa_songs_played_hard
        json['SASongsPlayedHardAndMore'].to_i
      end

      def sa_songs_played_master
        json['SASongsPlayedMaster'].to_i
      end

      def sa_songs_cleared_hard
        json['SANumSongsClearedHard'].to_i
      end

      def sa_songs_cleared_master
        json['SANumSongsClearedMaster'].to_i
      end
    end
  end
end
