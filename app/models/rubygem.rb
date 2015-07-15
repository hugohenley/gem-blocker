class Rubygem < ActiveRecord::Base
  has_one :gemblocker
  has_many :versions
end
