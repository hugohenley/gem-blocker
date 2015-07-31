module VerifyProjectsHelper

  def project_name(project_hash)
    project_hash.keys.first
  end

  def locked_gems(project_hash, type)
    gems = ""
    locked_gems = project_hash.values[0].find { |x| x[type] }
    if locked_gems[type].empty?
      return content_tag(:span, "Everything ok!", class: ["label", "label-success"])
    else
      locked_gems[type].each do
        return content_tag(:span, "Failed! :(", class: ["label", "label-danger"])
        #gems += "#{key} => #{value}\n"
        #gems
      end
    end
    #gems
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
          errors = "#{key} -> (#{value})"
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

end
