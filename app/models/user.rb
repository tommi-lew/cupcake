class User < ActiveRecord::Base
  validates_presence_of :name, :email, :pt_id

  scope :enabled, -> { where(enabled: true) }
  scope :product, -> { where("'product' = ANY(roles)") }
  scope :developer, -> { where("'dev' = ANY(roles)") }
end
