module ApplicationHelper
  def streamripper_installed?
    system("which streamripper > /dev/null 2>&1")
  end
end
