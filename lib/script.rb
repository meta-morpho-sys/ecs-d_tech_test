# frozen_string_literal: true

Script = Struct.new(:dir, :file_name)

# Returns the version, file_path and contents of a given script
class Script
  # returns the version of the script
  def version
    file_name[/\d+/].to_i
  end

  # returns a string with the file_path
  def file_path
    File.join(dir, file_name)
  end

  def read
    File.read file_path
  end
end

# Accesses a given dir and returns an array of scrypts
class Scripts
  def self.look_up(dir)
    discard_dirs(dir).map { |f| Script.new(dir, f) }
  end

  def self.discard_dirs(dir)
    scripts = Dir.entries(dir).reject { |e| File.directory? e }
    raise 'No scripts found' if scripts.empty?
    scripts
  end
end
