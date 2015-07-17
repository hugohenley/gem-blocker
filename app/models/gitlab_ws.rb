require 'rest-client'

class GitlabWS
  attr_reader :id, :commit_sha

  def initialize(id = nil, sha = nil)
    @id = id
    @commit_sha = sha
  end

  def project_info
    RestClient.get GITLAB_WS_URL + "projects/#{@id}", {:private_token => GITLAB_TOKEN}
  end

  def all_projects_info
    JSON(RestClient.get GITLAB_WS_URL + "projects/all", {:params => {:private_token => GITLAB_TOKEN, :per_page => 999}})
  end

  # Last commit comes first
  def project_commits
    begin
      JSON(RestClient.get GITLAB_WS_URL + "projects/#{@id}/repository/commits", {:private_token => GITLAB_TOKEN})
    rescue Exception
      return []
    end
  end

  def raw_gemfilelock
    RestClient.get GITLAB_WS_URL + "projects/#{@id}/repository/blobs/#{@commit_sha}", {:params => {:private_token => GITLAB_TOKEN, :filepath => "Gemfile.lock"}}
  end

end