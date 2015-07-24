class RenameGitlabIdToGitprojectId < ActiveRecord::Migration
  def change
    rename_column :projects, :gitlab_id, :gitproject_id
  end
end
