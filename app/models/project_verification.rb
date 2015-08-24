class ProjectVerification

  def verify! project
    project_with_gems = {}
    used_gems = last_used_gems_of project
    return if used_gems.nil?
    project_with_gems["#{project.name}"] = []
    required_gems = verify_locked_gems(used_gems, :required)
    not_present_gems = verify_not_present_gems(used_gems)
    allowed_gems = verify_locked_gems(used_gems, :allow_if_present)
    denied_gems = verify_locked_gems(used_gems, :deny)

    project_with_gems["#{project.name}"] << required_gems
    project_with_gems["#{project.name}"] << not_present_gems
    project_with_gems["#{project.name}"] << allowed_gems
    project_with_gems["#{project.name}"] << denied_gems
    project_with_gems
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

  def verify_locked_gems(used_gems, type)
    locked_gems = {type => {}}
    gems_of_type = Gemblocker.hash_of type.to_s.titleize
    gems_of_type.each do |required_gem|
      gem_name = required_gem.keys.first
      if used_gems[gem_name] && type != :deny
        unless required_gem[gem_name].include? used_gems[gem_name]
          locked_gems[type]["#{gem_name}"] = used_gems[gem_name]
        end
      else
        if required_gem[gem_name].include? used_gems[gem_name]
          locked_gems[type]["#{gem_name}"] = used_gems[gem_name]
        end
      end
    end
    locked_gems
  end

  def verify_not_present_gems(used_gems)
    type = :required
    locked_gems = {:not_present => {}}
    required_gems = Gemblocker.hash_of type.to_s.titleize
    required_gems.each do |required_gem|
      gem_name = required_gem.keys.first
      if !used_gems.keys.include? gem_name
        locked_gems[:not_present]["#{gem_name}"] = required_gem[gem_name]
      end
    end
    locked_gems
  end

end