class Project < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  accepts_nested_attributes_for :commits

  def self.already_imported?(project)
    Project.where(gitlab_id: project["id"]).any?
  end

end
