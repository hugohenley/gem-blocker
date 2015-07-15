class GemfileParser
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    file = File.open(@file_path).readlines.join("")
    lockfile = Bundler::LockfileParser.new(file)
    lockfile_gems = {}
    lockfile.specs.each { |s| lockfile_gems[s.name] = s.version.version }
    lockfile_gems
  end

end