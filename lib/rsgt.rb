require "tmpdir"
require "fileutils"
require "shellwords"
require "bindata"
require "zlib"
require "json"
require "openssl"
require "active_support"
require "active_support/core_ext"

begin
  require "pry"
rescue LoadError
end

require "rsgt/version"
require "rsgt/command_runner"
require "rsgt/rs_custom_song_toolkit"
require "rsgt/unpacked_psarc"
require "rsgt/vocals_extractor"
require "rsgt/audio_extractor"
require "rsgt/wwise_converter"
require "rsgt/repacker"
require "rsgt/wav_shifter"
require "rsgt/multipacker/config_processor"
require "rsgt/steam"
require "rsgt/encrypted_steam_file"
require "rsgt/saved_game/song_collection"
require "rsgt/saved_game/score_attack/song"
require "rsgt/saved_game/statistics/song"
require "rsgt/saved_game/learn_a_song/song"
require "rsgt/saved_game/statistics"
require "rsgt/saved_game"
require "rsgt/multipacker"
require "rsgt/cli"

module RSGuitarTech
  class << self
    attr_accessor :verbose
    @verbose = false
  end
end
