class Article < ApplicationRecord
    belongs_to :user
    #belongs_to :article_category
    validates :title, length: {maximum: 255}
    validates :description, length: {maximum: 4096}
    #has_many :categories
    has_and_belongs_to_many :categories
end