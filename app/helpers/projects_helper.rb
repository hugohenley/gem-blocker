module ProjectsHelper
  def last_commit_time(project)
    project.commits.last.commit_created_at if project.commits.any?
  end

  def last_commit_author(project)
    project.commits.last.author_name if project.commits.any?
  end
end
