class GemImporter
  attr_reader :git_project_id, :commit

  def initialize(git_project_id, commit)
    @git_project_id = git_project_id
    @commit = commit
  end

  def import
    begin
      raw_file = GitlabWS.new(@git_project_id, @commit.hash_id).raw_gemfilelock
      project_gems = GemfileParser.new(raw_file).parse
      project_gems.each_key do |gem_name|
        rubygem = Rubygem.where(name: gem_name).first_or_create
        version = Version.where(number: project_gems[gem_name], rubygem_id: rubygem.id).first_or_create
        UsedGem.new(commit_id: @commit.id, name: rubygem.name, version: version.number).save
      end
    rescue Exception => e
      puts e.message
      puts "*********************** PROJETO #{@git_project_id} NAO TEM GEMFILE *******************************"
      false
    end
  end

end