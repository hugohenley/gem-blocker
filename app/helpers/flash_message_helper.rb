module FlashMessageHelper

  def flash_message level, content
    content_tag :div, content, class: level
  end

  def flash_messages
    [:alert, :notice, :error, :success].map do |level|
      case level
        when :notice
          flash_message("alert alert-success", flash[level]) if flash[level]
        when :error
          flash_message("alert alert-danger", flash[level]) if flash[level]
        when :alert
          flash_message("alert alert-warning", flash[level]) if flash[level]

      end
    end.join.html_safe

  end

end