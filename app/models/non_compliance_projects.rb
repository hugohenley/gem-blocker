class NonComplianceProjects

  def list
    projects = []
    Project.all.each do |project|
      used_gems = last_used_gems_of project
      next if used_gems.nil?
      required_gems = verify_required_gems(project, used_gems)
      projects << required_gems if required_gems
    end
    projects
  end

  def last_used_gems_of project
    used_gems = []
    hash = {}
    return if project.commits.empty?
    gems = project.commits.last.used_gems
    gems.each do |gem|
      hash["#{gem.name}"] = gem.version
      used_gems << hash
    end
    hash
  end

  def verify_required_gems(project, used_gems)
    project_with_gems = {}
    blocked_gems = {}
    required_gems = Gemblocker.hash_of "Required"
    required_gems.each do |required_gem|
      gem_name = required_gem.keys.first
      if used_gems[gem_name]
        unless required_gem[gem_name].include? used_gems[gem_name]
          blocked_gems["#{gem_name}"] = used_gems[gem_name]
        end
      end
    end
    if blocked_gems.any?
      project_with_gems["#{project.name}"] = blocked_gems
      project_with_gems
    end
  end

  def verify_allowed_gems(used_gems)

  end

  def verify_denied_gems(used_gems)

  end


end