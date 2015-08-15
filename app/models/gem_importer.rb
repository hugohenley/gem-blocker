class GemImporter
  attr_reader :git_project_id, :commit, :server

  def initialize(git_project_id, commit, server)
    @git_project_id = git_project_id
    @commit = commit
    @server = server
  end

  def import
    begin
      raw_file = GitServer.new(@git_project_id, @commit.hash_id).raw_gemfilelock(@server)
      commit_gems = GemfileParser.new(raw_file).parse
      all_commits = self.array_of_commits_with_gems @git_project_id
      commit_gems.each_key do |gem_name|
        rubygem = Rubygem.where(name: gem_name).first_or_create
        version = Version.where(number: commit_gems[gem_name], rubygem_id: rubygem.id).first_or_create
        diff = GemComparer.new(all_commits).compare_with_last(rubygem, @commit.hash_id)
        UsedGem.new(commit_id: @commit.id, name: rubygem.name, version: version.number, diff: diff).save
      end
    rescue Exception => e
      false
    end
  end

  def array_of_commits_with_gems gitproject_id
    parsed_commits = []
    commits = Project.where("gitproject_id": gitproject_id).first.commits
    commits.each do |commit|
      begin
        hash = {}
        raw_file = GitServer.new(gitproject_id, commit.hash_id).raw_gemfilelock(@server)
        hash["#{commit.hash_id}"] = GemfileParser.new(raw_file).parse
        parsed_commits << hash
      rescue Exception
        next
      end
    end
    parsed_commits
  end


  def project_compliance?(project_hash)
    project_hash.values[0].each do |type|
      return false if type.values.first.any?
    end
    true
  end

end