require 'bundler'

class GemfileAnalyzer
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def blocked_gems
    blocked_gems = []
    used_gems_versions = GemfileParser.new(@file_path).parse_file
    used_gems_versions.each_key do |gem_name|
      if blocked_gem?(gem_name, used_gems_versions[gem_name])
        blocked_gems << {:gem_name => used_gems_versions[gem_name]}
      end
    end
    blocked_gems
  end

  def blocked_gem?(gem_name, version)
    blocked_gems = Gemblocker.list
    if blocked_gems[gem_name]
      # {"actionmailer"=>["4.1.8", "4.1.7"]}
      blocked_gems[gem_name].include? version ? true : false
    end
  end

end