module RSGuitarTech
  class SavedGame
    class SongCollection
      attr_accessor :collection

      delegate :values, :[], to: :collection

      def initialize(klass, json)
        @collection = json.inject({}) do |memo, (key, value)|
          memo[key] = klass::Song.from(key, value)
          memo
        end
      end
    end
  end
end
