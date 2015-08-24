class NonComplianceProjects

  def list
    projects = []
    Project.all.each do |project|
      project_with_gems = ProjectVerification.new.verify! project
      next if project_with_gems.nil?
      projects << project_with_gems unless project_with_gems["#{project.name}"].empty?
    end
    projects
  end

end