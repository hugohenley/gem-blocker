class Version < ActiveRecord::Base
  has_one :versionblocker
  belongs_to :rubygem
end
