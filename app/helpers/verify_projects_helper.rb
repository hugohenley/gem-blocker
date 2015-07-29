module VerifyProjectsHelper

  def project_name(project_hash)
    project_hash.keys.first
  end

  def locked_gems(project_hash, type)
    gems = ""
    locked_gems = project_hash.values[0].find { |x| x[type] }
    if locked_gems[type].empty?
      content_tag(:span, "Everything ok!", class: ["label", "label-success"])
    else
      locked_gems[type].each do |key, value|
        gems += "#{key} => #{value}\n"
        gems
      end
    end

  end
end
