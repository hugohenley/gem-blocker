module GemblockerHelper
  def blocked_versions(gemblocker)
    gemblocker.blockedversions.collect do |version|
      content_tag(:span, version.number, class: ["label", "label-warning", "span6"])
    end.join.html_safe
  end

end