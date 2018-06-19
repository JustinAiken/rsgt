module RSGuitarTech
  class EncryptedSteamFile < BinData::Record
    endian :little

    string :evas,   read_length: 4 # Is always 'EVAS'
    uint32 :version                # Is always 1
    uint64 :profile                # Steam profile
    uint32 :len
    rest   :payload

    KEY = [
      0x72, 0x8B, 0x36, 0x9E, 0x24, 0xED, 0x01, 0x34,
    	0x76, 0x85, 0x11, 0x02, 0x18, 0x12, 0xAF, 0xC0,
    	0xA3, 0xC2, 0x5D, 0x02, 0x06, 0x5F, 0x16, 0x6B,
    	0x4B, 0xCC, 0x58, 0xCD, 0x26, 0x44, 0xF2, 0x9E
    ].pack('C*')

    def decrypted
      aes = cipher_klass.new "AES-256-ECB"
      aes.decrypt
      aes.key     = KEY
      aes.padding = 0

      aes.update(payload) + aes.final
    end

    def encrypted
      aes = cipher_klass.new "AES-256-ECB"
      aes.encrypt
      aes.key     = KEY
      aes.padding = 0

      aes.update(payload) + aes.final
    end

    def uncompressed
      Zlib::Inflate.inflate decrypted
    end

    def uncompressed_json
      JSON.parse uncompressed.strip
    end

  private

    def cipher_klass
      defined?(OpenSSL::Cipher) ? OpenSSL::Cipher : OpenSSL::Cipher::Cipher
    end
  end
end
