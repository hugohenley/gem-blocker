class GemImporter
  attr_reader :project_id, :commit_sha

  def initialize(project_id, commit_sha)
    @project_id = project_id
    @commit_sha = commit_sha
  end

  def import
    raw_file = GitlabWS.new(@project_id, @commit_sha).raw_gemfilelock
    project_gems = GemfileParser.new(raw_file).parse
    project_gems.each_key do |gem_name|
      @rubygem = Rubygem.where(name: gem_name).first_or_create
      @version = Version.where(number: project_gems[gem_name], rubygem_id: @rubygem.id).first_or_create
    end
  end

end