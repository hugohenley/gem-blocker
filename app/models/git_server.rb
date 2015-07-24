class GitServer
  attr_reader :id, :commit_sha

  def initialize(id = nil, sha = nil)
    @id = id
    @commit_sha = sha
  end

  def all_projects_info(type)
    to_class(type).new.all_projects_info
  end

  def project_info(type)
    to_class(type).new.project_info(@commit_sha)
  end

  def project_commits(type)
    to_class(type).new.project_commits(@id)
  end

  def raw_gemfilelock(type)
    to_class(type).new.raw_gemfilelock(@id, @commit_sha)
  end

  def to_class(type)
    (type.to_s.titleize + "Server").constantize
  end

end