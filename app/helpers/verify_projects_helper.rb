module VerifyProjectsHelper

  def project_name(project_hash)
    project_hash.keys.first
  end

  def status_for_type(project_hash, type)
    locked_gems = project_hash.values[0].find { |x| x[type] }
    locked_gems[type].empty? ? true : false
  end

  def status project_hash
    final_status = true
    types = Gemblocker::VERIFIED_TYPES.map { |x| x.downcase.tr(" ", "_").to_sym.downcase }
    types.each do |type|
      unless status_for_type(project_hash, type)
        final_status = false
      end
    end

    if final_status
      return content_tag(:span, "Everything ok!", class: ["label", "label-success"])
    else
      return content_tag(:span, "Failed! :(", class: ["label", "label-danger"])
    end
  end

  def actual_blocker_version(gem_name)
    versions = ""
    Gemblocker.where(gem: gem_name).take.blockedversions.each do |version|
      versions += content_tag(:span, "#{version.number} ", class: ["label", "label-danger"])
    end
    versions.html_safe
  end

  def details_for(project_hash)
    message = ""
    required = []
    allow_if_present = []
    not_present = []
    deny = []
    types = Gemblocker::VERIFIED_TYPES.map { |x| x.downcase.tr(" ", "_").to_sym.downcase }
    types.each do |type|
      locked_gems = project_hash.values[0].find { |x| x[type] }
      unless locked_gems[type].empty?
        locked_gems[type].each do |key, value|
          errors = "#{key} (#{value}) -> (#{blocked_versions_for key})"
          case type
            when :required
              required << errors
            when :allow_if_present
              allow_if_present << errors
            when :not_present
              not_present << errors
            when :deny
              deny << errors
          end
        end
      end
    end
    message += "The following gems are present but are in the wrong version: #{required.join(", ")}, please update.\n" unless required.empty?
    message += "The following gems are allowed but are in the wrong version: #{allow_if_present.join(", ")}, please update.\n" unless allow_if_present.empty?
    message += "The following gems are required but not present: #{not_present.join(", ")}, please include them.\n" unless not_present.empty?
    message += "The following gems are not allowed: #{deny.join(", ")}, please exclude them.\n" unless deny.empty?
    message
  end

  def blocked_versions_for gem
    versions = []
    Gemblocker.where(gem: gem).take.blockedversions.each do |version|
      versions << version.number
    end
    versions.join(", ")
  end

end
