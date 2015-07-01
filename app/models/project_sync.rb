class ProjectSync

  def self.start!
    projects = GitlabWS.new.all_projects_info

  end
end