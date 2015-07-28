class NonComplianceProjects

  def list
    projects = []
    Project.all.each do |project|
      project_with_gems = {}
      used_gems = last_used_gems_of project
      next if used_gems.nil?
      project_with_gems["#{project.name}"] = []
      required_gems = verify_required_gems(used_gems)
      project_with_gems["#{project.name}"] << required_gems
      projects << project_with_gems unless project_with_gems["#{project.name}"].empty?
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

  def verify_required_gems(used_gems)
    blocked_gems = { required: { } }
    required_gems = Gemblocker.hash_of "Required"
    required_gems.each do |required_gem|
      gem_name = required_gem.keys.first
      if used_gems[gem_name]
        unless required_gem[gem_name].include? used_gems[gem_name]
          blocked_gems[:required]["#{gem_name}"] = used_gems[gem_name]
        end
      end
    end
    blocked_gems if blocked_gems[:required].any?
  end

  def verify_allowed_gems(used_gems)

  end

  def verify_denied_gems(used_gems)

  end


end