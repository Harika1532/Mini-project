class User < ApplicationRecord
	has_secure_password
	has_many :articles
	has_many :comments

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