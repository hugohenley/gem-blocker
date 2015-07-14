module ProjectsHelper
  def last_commit_time(project)
    project.commits.last.commit_created_at if project.commits.any?
  end
end
