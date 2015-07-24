require 'rest-client'

class GitlabServer

  def all_projects_info
    JSON(RestClient.get GITLAB_WS_URL + "projects/all", {:params => {:private_token => GITLAB_TOKEN, :per_page => 999}})
  end

  def project_info(id)
    RestClient.get GITLAB_WS_URL + "projects/#{id}", {:private_token => GITLAB_TOKEN}
  end

  # Last commit comes first
  def project_commits(id)
    begin
      JSON(RestClient.get GITLAB_WS_URL + "projects/#{id}/repository/commits", {:private_token => GITLAB_TOKEN})
    rescue Exception
      return []
    end
  end

  def raw_gemfilelock(id, sha)
    RestClient.get GITLAB_WS_URL + "projects/#{id}/repository/blobs/#{sha}", {:params => {:private_token => GITLAB_TOKEN, :filepath => "Gemfile.lock"}}
  end

end