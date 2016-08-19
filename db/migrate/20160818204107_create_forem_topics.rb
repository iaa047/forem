class CreateForemTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :forem_topics do |t|
      t.references :user, index: true
      t.references :forum, index: true
      t.string     :permalink, null: :false
      t.string     :title,     null: :false
      t.text       :description
      t.integer    :state,     null: :false, default: 0
      t.date       :deleted_at

      t.timestamps

      t.index :permalink
      t.index :state
      t.index [:permalink, :forum_id], unique: true
    end
  end
end
