require "yaml"

module RSGuitarTech
  class Multipacker
    class ConfigProcessor

      attr_accessor :config

      def initialize(opts)
        @config = YAML.load_file opts[:config]
        @packed = []
      end

      def process!
        config["repacks"].each do |config_data|
          packer = packer_for config_data
          packer.process!
          packer.send(:psarcs).each do |packed_psarc|
            @packed << packed_psarc.split("/").last.split(" _m").first
          end
        end
      end

    private

      def packer_for(config_data)
        RSGuitarTech::Multipacker.new(
          title:      config_data["title"],
          directory:  config_data["directory"],
          unpack_dir: config_data["unpack_dir"],
          repack_dir: config_data["repack_dir"],
          dest_dir:   config["destination"],
          options:    {
            reset_unpack: config_data["options"]["reset_unpack"],
            reset_repack: config_data["options"]["reset_repack"]
          },
          filters: {
            reject: @packed
          }
        )
      end
    end
  end
end
