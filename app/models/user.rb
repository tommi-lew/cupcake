class User < ActiveRecord::Base
  validates_presence_of :name, :email, :pt_id
end
