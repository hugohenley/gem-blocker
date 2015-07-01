require 'rest-client'

class GitlabWS
  attr_reader :id

  URL = "https://sistemas.uff.br/sti/git/api/v3/"

  def initialize(id)
    @id = id
  end

  def project_info
    RestClient.get URL + "projects", {:params => {:id => @id, :private_token => GITLAB_TOKEN } }
  end

end