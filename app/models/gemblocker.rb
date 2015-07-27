class Gemblocker < ActiveRecord::Base
  has_many :blockedversions
  accepts_nested_attributes_for :blockedversions, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :gem, :verification_type
  validate :allowed_types

  ALLOWED_TYPES = ["Required", "Allow if present", "Deny"]

  def allowed_types
    unless ALLOWED_TYPES.include? verification_type
      errors.add(:verification_type, 'This type is not allowed.')
    end
  end

end
