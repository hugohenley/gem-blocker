class Commit < ActiveRecord::Base
  belongs_to :project
  has_many :used_gems, :dependent => :destroy

  def previous
    self.class.where("id > ?", id).first
  end

  def next
    self.class.where("id < ?", id).last
  end

  def self.already_imported?(commit)
    Commit.where(hash_id: commit["id"]).any?
  end

  def gitproject_id
    self.project.gitproject_id
  end

  def commit_server
    self.project.server
  end

end
