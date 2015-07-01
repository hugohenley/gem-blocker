class AddProjectIdToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :project_id, :integer
  end
end
