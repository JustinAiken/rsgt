require "shellwords"
require "open3"

module RSGuitarTech
  class CommandRunner

    def self.run!(args, skip_escaping: false)
      self.new(args, skip_escaping: skip_escaping).run!
    end

    attr_accessor :cmd

    def initialize(args, skip_escaping: false)
      if skip_escaping
        @cmd = Array(args).join " "
      else
        @cmd = Shellwords.join Array(args)
      end
    end

    def run!
      if RSGuitarTech.verbose
        puts "*" * 40
        puts ""
        puts cmd
        puts ""
      end

      stdout, stderr, status = Open3.capture3(cmd)
      if RSGuitarTech.verbose
        stdout.split("\n").each do |line|
          puts "--- #{line}"
        end
        stderr.split("\n").each do |line|
          puts "!!! #{line}"
        end
      end
      status
    end
  end
end
