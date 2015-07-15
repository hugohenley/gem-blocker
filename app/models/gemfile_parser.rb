class GemfileParser
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def parse
    lockfile = Bundler::LockfileParser.new(@file)
    lockfile_gems = {}
    lockfile.specs.each { |s| lockfile_gems[s.name] = s.version.version }
    lockfile_gems
  end

end