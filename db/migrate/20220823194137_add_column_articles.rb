class AddColumnArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :likes_count, :integer, default: 0
    add_column :articles, :dislikes_count, :integer, default: 0
  end
end
