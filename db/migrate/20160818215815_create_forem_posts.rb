class CreateForemPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :forem_posts do |t|
      t.references :user,     index: true
      t.references :topic,    index: true
      t.references :reply_to, index: true
      t.text       :body
      t.integer    :state,     null: :false, default: 0
      t.date       :deleted_at

      t.timestamps

      t.index :state
    end
  end
end
