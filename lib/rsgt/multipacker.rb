module RSGuitarTech
  class Multipacker

    def self.process!(*args)
      self.new(*args).process!
    end

    attr_accessor *%i{title directory unpack_dir repack_dir dest_dir filters options count}

    def initialize(title:, directory:, unpack_dir:, repack_dir:, dest_dir:, filters: {}, options: {})
      @title      = title
      @directory  = directory
      @unpack_dir = unpack_dir
      @repack_dir = repack_dir
      @dest_dir   = dest_dir
      @filters    = filters
      @options    = options
      @count      = {psarcs: 0, skipped: 0, failed: 0, total: 0}
    end

    def process!
      reset! unpack_dir if options[:reset_unpack]
      reset! repack_dir if options[:reset_repack]
      ensure_dir! unpack_dir
      ensure_dir! repack_dir
      unpack!
      if count[:skipped] >= count[:total]
        puts "All done! No new files found to repack"
        return
      end
      repack!
      move!
    end

    def reset!(dir)
      shell_out "rm -rf #{dir}"
    end

    def ensure_dir!(dir)
      shell_out "mkdir -p #{dir}/"
    end

    def unpack!
      filtered_psarscs.each do |dlc|
        if unpack dlc
          count[:total] = count[:total] + 1
        else
          count[:failed] = count[:failed] + 1
        end
      end
    end

    def repack!
      puts "Packing #{count[:total]} songs into #{repack_dir}.psarc"
      shell_out %Q{pyrocksmith --no-crypto --pack "#{repack_dir}"}
    end

    def move!
      packed_psarc = repack_dir.split("/").last + ".psarc"
      puts "Moving packed psarc (#{packed_psarc}) to: #{title} - #{count[:total]} songs _m.psarc"
      shell_out "mv #{packed_psarc} #{dest_dir}/#{title}\\ \\-\\ #{count[:total]}\\ songs\\ \\_m.psarc"
    end

  private

    def unpack(dlc)
      count[:psarcs] = count[:psarcs] + 1
      base_name = File.basename dlc, '.*'

      if Dir.exists? "#{unpack_dir}/#{base_name}"
        puts "Skipping #{dlc} (#{base_name})"
        count[:skipped] = count[:skipped] + 1
        return true
      end

      puts "Unpacking #{dlc} (#{base_name})"

      return false unless shell_out %Q{pyrocksmith --no-crypto --unpack "#{dlc}"}
      return false unless shell_out %Q{mv "#{base_name}/" #{unpack_dir}/}
      return false unless shell_out %Q{ditto "#{unpack_dir}/#{base_name}/" "#{repack_dir}"}

      true
    end

    def filtered_psarscs
      @filtered_psarscs ||= begin
        reject_filters = Array(filters[:reject]).flatten
        select_filters = Array(filters[:select]).flatten
        limit          = options[:limit]

        _fp = psarcs
        _fp = _fp.take(limit) if limit
        _fp = _fp.reject { |filename| reject_filters.include? simplfied(filename) } if reject_filters.any?
        _fp = _fp.select { |filename| select_filters.include? simplfied(filename) } if select_filters.any?
        _fp
      end
    end

    def psarcs
      @psarcs ||= Dir.glob("#{directory}/*.psarc")
    end

    def simplfied(filename)
      filename.split("/").last.split(" _m").first
    end

    def shell_out(cmd)
      puts cmd if options[:verbose]
      return true if system(cmd)
      puts "FAILED: #{cmd}"
      false
    end
  end
end
