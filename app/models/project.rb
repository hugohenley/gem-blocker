class Project < ActiveRecord::Base
  has_many :commits

  accepts_nested_attributes_for :commits
end
