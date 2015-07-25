class GemImporter
  attr_reader :git_project_id, :commit, :all_commits, :server

  def initialize(git_project_id, commit, all_commits, server)
    @git_project_id = git_project_id
    @commit = commit
    @all_commits = all_commits
    @server = server
  end

  def import
    begin
      raw_file = GitServer.new(@git_project_id, @commit.hash_id).raw_gemfilelock(@server)
      commit_gems = GemfileParser.new(raw_file).parse
      commits = self.array_of_commits_with_gems(raw_file)
      commit_gems.each_key do |gem_name|
        rubygem = Rubygem.where(name: gem_name).first_or_create
        version = Version.where(number: commit_gems[gem_name], rubygem_id: rubygem.id).first_or_create

        diff = GemComparer.new(commits).compare_with_last(rubygem, @commit.hash_id)

        UsedGem.new(commit_id: @commit.id, name: rubygem.name, version: version.number, diff: diff).save
      end
    rescue Exception => e
      false
    end
  end

  def array_of_commits_with_gems(raw_file)
    commits = []
    @all_commits.each do |commit|
      commits << { commit["id"] => GemfileParser.new(raw_file).parse }
    end
    commits
  end

end