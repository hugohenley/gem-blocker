class Project < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  accepts_nested_attributes_for :commits

  def self.already_imported?(id, server)
    Project.where(gitproject_id: id, server: server).any?
  end

end
