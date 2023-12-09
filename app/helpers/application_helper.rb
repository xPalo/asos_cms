module ApplicationHelper
  def current_class?(test_path, color="")
    return "active #{color}" if request.path == test_path
    " "
  end

  def dark_mode_enabled?
    if cookies[:dark_mode].present? && ActiveModel::Type::Boolean.new.cast(cookies[:dark_mode].to_s)
      "dark"
      true
    else
      "success"
      false
    end
  end
end
