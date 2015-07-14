module ApplicationHelper

  def bootstrap_class_for flash_type
    pry
    case flash_type.to_sym
      when :notice
        "success"
      when :success
        "success"
      when :error
        "danger"
      when :warning
        "warning"
      when :info
        "info"
      else
        flash_type.to_s
    end
  end


end
