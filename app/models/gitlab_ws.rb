require 'rest-client'

class GitlabWS
  attr_reader :id

  def initialize(id = nil)
    @id = id
  end

  def project_info
    RestClient.get GITLAB_WS_URL + "projects/#{@id}", {:private_token => GITLAB_TOKEN}
  end

  def all_projects_info
    JSON(RestClient.get GITLAB_WS_URL + "projects/all", {:params => {:private_token => GITLAB_TOKEN, :per_page => 999}})
  end

  def project_commits
    begin
      JSON(RestClient.get GITLAB_WS_URL + "projects/#{@id}/repository/commits", {:private_token => GITLAB_TOKEN})
    rescue Exception
      return []
    end

  end

end