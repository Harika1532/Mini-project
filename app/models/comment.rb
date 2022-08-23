class Comment < ApplicationRecord
	belongs_to :article
	belongs_to :user
	validates  :review, length: {maximum: 255}
end
