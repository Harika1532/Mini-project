class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.integer :word_count
      t.integer :user_id
      t.string :approved
      t.timestamps
    end
    add_index :articles, :title, unique:true
    add_index :articles, :description, unique:true
  end
end
