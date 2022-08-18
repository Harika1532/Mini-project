class Category < ApplicationRecord
#belongs_to :article_category
    # has_many :articles
    has_and_belongs_to_many :articles
end