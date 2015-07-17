module CommitsHelper

  # def compare_with_last(commit, used_gem)
  #   previous_commit = commit.previous
  #   if same_project?(commit, previous_commit)
  #     used_gem_last_commit = previous_commit.used_gems.where(name: used_gem.name)
  #     if used_gem_last_commit.any?
  #       print_delta(used_gem, used_gem_last_commit.first)
  #     else
  #       content_tag(:span, "First use", class: "label label-info")
  #     end
  #   end
  # end
  #
  # def same_project?(actual_commit, another_commit)
  #   actual_commit.project == another_commit.project ? true : false
  # end

  def print_delta(used_gem)
    if used_gem.diff == "up"
      image_tag "arrow_up.png"
    elsif used_gem.diff == "down"
      image_tag "arrow_down.png"
    else
      image_tag "equal.png"
    end
  end

end
