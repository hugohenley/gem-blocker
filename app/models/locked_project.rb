class LockedProject

  def list_all
    projects = NonComplianceProjects.new.list
    projects.each do |project|

    end
  end
end