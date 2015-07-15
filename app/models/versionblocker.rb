class Versionblocker < ActiveRecord::Base
  belongs_to :version
  belongs_to :gemblocker

end
