class Article < ApplicationRecord
    belongs_to :user
    validates :title, length: {maximum: 255}
    validates :description, length: {maximum: 4096}
    has_many :comments
    has_and_belongs_to_many :categories

end