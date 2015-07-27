class Gemblocker < ActiveRecord::Base

  validates_presence_of :gem, :version, :verification_type
  validate :allowed_types

  ALLOWED_TYPES = ["Required", "Deny if present", "Deny"]

  def allowed_types
    unless ALLOWED_TYPES.include? verification_type
      errors.add(:verification_type, 'This type is not allowed.')
    end
  end

end
