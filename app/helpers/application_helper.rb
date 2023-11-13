module ApplicationHelper
  def current_class?(test_path, color="")
    return "active #{color}" if request.path == test_path
    " "
  end

  def dark_mode_enabled?
    current_user.try(:setting).try(:has_darkmode) ? "bg-dark" : "bg-success"
  end
end
