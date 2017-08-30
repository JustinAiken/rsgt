module RSGuitarTech
  class WWiseConverter

    TEMPLATE_TAR_BZ  = "/Applications/RocksmithCustomSongToolkit.app/Contents/Resources/WwiseYEAR.tar.bz2"

    attr_accessor :source_file, :wwise_version, :quality, :chorus, :dir

    def initialize(source_file, opts = {})
      @source_file   = source_file
      @wwise_version = opts[:wwise_ver]
      @quality       = opts[:quality]
      @chorus        = opts[:chorus]
    end

    def convert!
      Dir.mktmpdir do |dir|
        @dir = dir

        extract_base_template
        prepare_template
        copy_source
        ffmpeg_preview
        run_wwise
        if wwise_version[0..3].to_i >= 2016
          downgrade_headers "#{template_dir}/GeneratedSoundBanks/Windows/144151451.wem"
          downgrade_headers "#{template_dir}/GeneratedSoundBanks/Windows/309608343.wem"
        end
        yield self
      end
    end

    def extract_base_template
      just_tar = template_tar_bz.gsub(".bz2", "")
      CommandRunner.run! ["bunzip2", "-k", template_tar_bz]     # Unzip Wwise2016.tar.bz2 to Wwise2016.tar
      CommandRunner.run! ["tar", "-xzvf", just_tar, "-C", dir]  # Untar Wwise2016.tar to the workdir
    end

    def prepare_template
      CommandRunner.run! ["mkdir", "-p", "#{template_dir}/.cache/Windows/SFX"]
      CommandRunner.run! ["sed", "-i.bak", "'s/%QF1%/#{quality}/'", default_work_unit.shellescape], skip_escaping: true
      CommandRunner.run! ["sed", "-i.bak", "'s/%QF2%/#{quality}/'", default_work_unit.shellescape], skip_escaping: true
    end

    def copy_source
      FileUtils.cp source_file, "#{template_dir}/Originals/SFX/Audio.wav"
    end

    def ffmpeg_preview
      CommandRunner.run! ["ffmpeg", "-i", source_file, "-ss", chorus, "-t", "30", "#{template_dir}/Originals/SFX/Audio_preview.wav"]
    end

    def run_wwise
      wwise_cmd = [
        wwise_cli,
        "#{template_dir}/Template.wproj",
        "-GenerateSoundBanks",
        "-Platform",
        "Windows",
        "-NoWwiseDat",
        "-ClearAudioFileCache",
        "-Save"
      ]
      wwise_cmd << "-Verbose" if RSGuitarTech.verbose
      CommandRunner.run! wwise_cmd
    end

    def downgrade_headers(file)
      CommandRunner.run! %Q{printf "$(printf '\\x%02X' 03)" | dd of=#{file} bs=1 seek=40 count=1 conv=notrunc}, skip_escaping: true
      CommandRunner.run! %Q{printf "$(printf '\\x%02X' 00)" | dd of=#{file} bs=1 seek=41 count=1 conv=notrunc}, skip_escaping: true
      CommandRunner.run! %Q{printf "$(printf '\\x%02X' 00)" | dd of=#{file} bs=1 seek=42 count=1 conv=notrunc}, skip_escaping: true
      CommandRunner.run! %Q{printf "$(printf '\\x%02X' 00)" | dd of=#{file} bs=1 seek=43 count=1 conv=notrunc}, skip_escaping: true
    end

    def results
      {
        main:    "#{template_dir}/GeneratedSoundBanks/Windows/144151451.wem",
        preview: "#{template_dir}/GeneratedSoundBanks/Windows/309608343.wem"
      }
    end

  private

    def template_dir
      "#{dir}/Template"
    end

    def template_tar_bz
      TEMPLATE_TAR_BZ.dup.gsub "YEAR", wwise_version[0..3]
    end

    def wwise_cli
      "/Applications/Audiokinetic/Wwise #{wwise_version}/Wwise.app/Contents/Tools/WwiseCLI.sh"
    end

    def default_work_unit
      "#{template_dir}/Interactive Music Hierarchy/Default Work Unit.wwu"
    end
  end
end
