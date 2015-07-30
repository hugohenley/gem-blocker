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
    errors = ""
    types = Gemblocker::ALLOWED_TYPES.map { |x| x.downcase.tr(" ", "_").to_sym.downcase }
    types.each do |type|
      locked_gems = project_hash.values[0].find { |x| x[type] }
      unless locked_gems[type].empty?
        locked_gems[type].each do |key, value|
          errors += "#{key} => #{value}\n"
        end
      end
    end
    errors
  end

end
