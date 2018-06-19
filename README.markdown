[![Gem Version](http://img.shields.io/gem/v/rsgt.svg)](https://rubygems.org/gems/rsgt)[![Build Status](http://img.shields.io/travis/JustinAiken/rsgt/master.svg)](http://travis-ci.org/JustinAiken/rsgt)[![Coveralls branch](http://img.shields.io/coveralls/JustinAiken/rsgt/master.svg)](https://coveralls.io/r/JustinAiken/rsgt?branch=master)

# Rocksmith Guitar Tech

Ruby 💎 tool for working with rocksmith songs, DLC, and profile data.
Almost certainly only useful for Mac.

## Installation

`gem install rsgt`

### Dependencies

Only Ruby 2.3+ is supported.

This tool relies on various bits of software to do the various bits of things it does...

- `pyrocksmith` (https://github.com/0x0L/rocksmith)
  - Needed for anything involving unpacking/repacking
  - Install by doing:
    - `brew install pip`
    - `pip3 install git+https://github.com/0x0L/rocksmith.git`
- WWise (https://www.audiokinetic.com/download/#macosx)
  - Needed if you're going to repack audio
- [Rocksmith Custom Song Toolkit](https://www.rscustom.net/)
  - Used for extracting audio out to ogg files
  - Used for sng <-> xml conversion (like changing vocals)
  - Installation:
    - Move to `/Applications`
    - `brew cask install mono-mdk`
    - `brew install wine winetricks`
- `ffmpeg`
  - `brew install ffmpeg`

## Usage: Uncensoring

For example...

```bash
# Extracts ragebomb_vocals.xml:
rsgt extract-vocals --psarc=ragekilling_m.psarc

# Edit the vocals file, putting back in missing words:
vim ragebomb_vocals.xml

# Extract the audio track to use as a guide track
# This creates output.ogg
rsgt extract-audio --psarc=ragekilling_m.psarc

# Using output.ogg as a guide track, take the real CD wav, line it up, save as fixed.wav
<AUDIO EDITING>

# Repack the fixed vocals and audio track back in:
rsgt \
  repack \
  --psarc=ragekilling_m.psarc \
  --vocals-xml=ragebomb_vocals.xml \
  --audio=fixed.wav
```

#### Repacking Options

You can also repack the preview if you want:

```bash
rsgt \
  repack \
  --psarc=ragekilling_m.psarc \
  --vocals-xml=ragebomb_vocals.xml \
  --audio=fixed.wav \
  --preview \
  --chorus=45
```

## Usage: Multipacker

The Multipacker can pack a bunch of psarcs into a single multipack.

For example, say you have this kind of folder structure:

```
~/rocksmith/songs
  /uncensored
    - Green Day - American Idiot_m.psarc
    ... some other songs
  /Official
    - Green Day - American Idiot_m.psarc
    ... hundreds of other songs
  /CDLC
    ... hundreds of custom songs
```

Then you'd create a config file such as:

```yaml
destination: ~/Library/Application\ Support/Steam/SteamApps/common/Rocksmith2014/dlc

repacks:
  - title:      Uncensored
    directory:  ~/rocksmith/songs/Uncensored
    unpack_dir: ~/rocksmith/unpacks/uncensored
    repack_dir: ~/rocksmith/repacks/uncensored
    options:
      reset_unpack: false
      reset_repack: false

  - title:      Official
    directory:  ~/rocksmith/songs/Official
    unpack_dir: ~/rocksmith/unpacks/official
    repack_dir: ~/rocksmith/repacks/official
    options:
      reset_unpack: false
      reset_repack: false

  - title:      Custom
    directory:  ~/rocksmith/songs/CDLC
    unpack_dir: ~/rocksmith/unpacks/cdlc
    repack_dir: ~/rocksmith/repacks/cdlc
    options:
      reset_unpack: false
      reset_repack: false
```

And running `rsgt multipack --config=thatfile.yml` would:
- Repack all of your uncensored songs into a single "Uncensored - n songs _m.psarc" file, and move it to your DLC folder.
- Repack all of your official songs into a single "Official - n songs _m.psarc" file, and move it to your DLC folder.
  - Leaving out songs that it already got from uncensored
- Repack all of your custom songs into a single "Custom - n songs _m.psarc" file, and move it to your DLC folder.

##### Notes:
- Make sure to check the RS DLC folder, and remove any duplicates - just leave the lastest of each multipack
- You can keep your `unpack`/`repack` directories around as a cache
- The "reset" options will nuke that folder:
  - If you're just adding songs, keep it as false, and it'll be zippy
  - If you're deleting/changing songs, change it to true, so stale copies don't get packed in

## Usage: Saved Game exploration

... this area is WIP, you probably don't want to mess with `RSGuitarTech::SavedGame` at all right now.

## License

MIT
