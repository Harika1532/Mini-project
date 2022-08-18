class User < ApplicationRecord
	has_secure_password
	# validates_confirmation_of :password
	# attr_accessor :password
 #  	validates :password, confirmation: true
	 validates :password, confirmation:true
	validates :password_confirmation, presence: true
	has_many :articles

	def user?
		role == 0
	end

	def admin?
		role == 1
	end
	def publisher?
		role == 2
	end
end