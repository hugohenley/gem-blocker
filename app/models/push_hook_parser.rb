class PushHookParser
  attr_reader :title, :author_name, :author_email, :commit_created_at, :git_project_id, :commits

  def initialize params
    @author_name = params[:user_name]
    @git_project_id = params[:project_id]
    @commits = params[:commits]
    @author_email = params[:user_email]
  end

  def save!
    project_id = Project.where(gitproject_id: @git_project_id).take.id
    @commits.each do |commit|
      Commit.create(author_name: @author_name,
                 author_email: @author_email,
                 project_id: project_id,
                 hash_id: commit[:id],
                 commit_created_at: commit[:timestamp],
                 title: commit[:message])
    end
  end

end