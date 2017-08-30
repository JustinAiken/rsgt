module RSGuitarTech
  class Steam

    ROCKSMITH2014_APP_ID = 221680

    def save_file
      "#{base_path}#{save_filename}"
    end

    def save_filename
      "#{unique_id}_PRFLDB"
    end

    def local_profiles
      "#{base_path}LocalProfiles.json"
    end

    # Uplay junk
    def crd
      "#{base_path}crd"
    end

    def unique_id
      @unique_id ||= begin
        file = File.open local_profiles
        data = RSGuitarTech::EncryptedSteamFile.read(file)
        data.uncompressed_json['Profiles'].first['UniqueID']
      end
    end

  private

    def base_path
      "#{steam_path}#{steam_id}/#{ROCKSMITH2014_APP_ID}/remote/"
    end

    def steam_path
      "/Users/#{`whoami`.strip}/Library/Application\ Support/Steam/userdata/"
    end

    def steam_id
      Dir["#{steam_path}/*"].first.match(/\/(\d+)$/)[1]
    end
  end
end
