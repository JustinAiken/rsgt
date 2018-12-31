require "optimist"

module RSGuitarTech
  class CLI

    SUB_COMMANDS = %w(extract-vocals extract-audio repack shift multipack)

    TOP_BANNER = <<~STRING
      Tool to work with RS DLC and saves
      USAGE: rsgt [options] command [command_options]

      Options for all commands:

    STRING

    USAGE = <<~STRING

    Available command are:
       extract-vocals: Extract a .xml of the vocals for editing
       extract-audio:  Extract the audio track as an .ogg (ie, to use as guide track)
       repack:         Repack altered lyrics/audio into a psarc
       shift:          Shift a .wav by ms
       multipack:      Repack multiple PSARCs into a single PSARC
    STRING

    def self.parse(args)
      global_opts = Optimist::options do
        banner TOP_BANNER
        opt :verbose, "More output", short: "-v"
        banner USAGE

        stop_on SUB_COMMANDS
      end

      cmd = args.shift # get the subcommand
      cmd_opts = case cmd
      when "extract-vocals"
        Optimist::options do
          banner "Extracts and converts vocals into an XML"
          opt :psarc,  "PSARC to extract",                type: :string, required: true
          opt :output, "Optional path to output the XML", type: :string
        end
      when "extract-audio"
        Optimist::options do
          banner "Extracts and converts the audio track into an .ogg"
          opt :psarc,  "PSARC to extract",                 type: :string, required: true
          opt :output, "Optional path to output the .ogg", type: :string
        end
      when "repack"
        Optimist::options do
          banner "Repack a psarc with new vocals XML and/or audio tracks"
          opt :psarc,      "PSARC to repack files into",                  type: :string,  required: true
          opt :vocals_xml, "Vocals XML file to repack",                   type: :string
          opt :audio,      "Audio file to repack",                        type: :string
          opt :wwise_ver,  "WWise version to use",                        type: :string,  default: "2016.2.4.6098"
          opt :quality,    "Quality of OGG encoding",                     type: :string,  default: "6"
          opt :preview,    "Flag to regenerate the preview",              type: :boolean, default: false
          opt :chorus,     "Seconds in to start the preview",             type: :string,  default: "30"
          opt :output,     "Optional place to output the repacked psarc", type: :string
        end
      when "shift"
        Optimist::options do
          banner "Shift a .WAV file by given MS"
          opt :wav,    "WAV file to shift",                        type: :string, required: true
          opt :dir,    "Direction to shift (forward or backward)", type: :string, required: true
          opt :amount, "Amount in MS",                             type: :string, required: true
        end
      when "multipack"
        Optimist::options do
          banner "Repack multiple PSARCs into a single PSARC"
          opt :config, "Config File", type: :string, required: true
        end
      else
        Optimist::educate
      end

      RSGuitarTech.verbose = true if global_opts[:verbose]
      RSGuitarTech.verbose = true if cmd_opts[:verbose]

      case cmd
      when "extract-vocals" then VocalsExtractor.new(cmd_opts).extract!
      when "extract-audio"  then AudioExtractor.new(cmd_opts).extract!
      when "repack"         then Repacker.new(cmd_opts).repack!
      when "shift"          then WavShifter.new(cmd_opts).shift!
      when "multipack"      then Multipacker::ConfigProcessor.new(cmd_opts).process!
      end
    end
  end
end
