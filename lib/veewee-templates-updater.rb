require 'archive/tar/minitar'
require 'fileutils'
require 'open-uri'
require 'zlib'

class VeeweeTemplatesUpdater
  def veewee_spec
    @veewee_spec ||=
      if Gem::Specification.respond_to?(:find_by_name)
        Gem::Specification.find_by_name("veewee")
      else
        Gem.source_index.find_name("veewee").last
      end
  end

  def veewee_target(source)
    # Remove the github project dir name it contains sha
    source.gsub!(/^[^\/]*\//,"")
    # Build path to local file/dir
    File.join(veewee_spec.full_gem_path,source)
  end

  def veewee_tarball_url
    "https://github.com/jedi4ever/veewee/tarball/master"
  end

  def handle_entry(entry)
    if entry.file?
      File.open(veewee_target(entry.name),"w") do |target|
        while body = entry.read
          target.write(body)
        end
      end
    else
      FileUtils.mkdir_p veewee_target(entry.name)
    end
  end

  def parse_archive res
    printf "Extracting: "
    Zlib::GzipReader.open(res) do |tgz|
      last_entry_name = ""
      Archive::Tar::Minitar::Reader.open(tgz).each do |entry|
        # handle only templates
        next unless entry.name =~ /^[^\/]*\/templates\/([^\/]*)\/.*$/
        # print name of template only for first path found
        printf "#{$1} " if last_entry_name != $1
        last_entry_name = $1
        # mkdir / unpack
        handle_entry entry
      end
    end
    printf "\n"
  end

  def run
    veewee_spec || raise("Could not find veewee gem, install it first.")
    puts "Veewee: #{veewee_spec.full_gem_path}"
    puts "Downloading: #{veewee_tarball_url}"
    open(veewee_tarball_url) do |res|
      parse_archive res
    end
  end
end
