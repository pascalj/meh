module ApplicationHelper
  def streamripper_installed?
    system("which streamripper > /dev/null 2>&1")
  end

  def episode_file_url(episode)
    "#{Settings[:episode_dl_prefix]}/#{episode.filename}"
  end

  def image_url(source)
    URI.join(root_url, source)
  end
end
