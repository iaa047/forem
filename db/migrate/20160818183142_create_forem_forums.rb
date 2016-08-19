class CreateForemForums < ActiveRecord::Migration[5.0]
  def change
    create_table :forem_forums do |t|
      t.references :user, index: true
      t.string     :permalink, null: :false
      t.string     :title,     null: :false
      t.text       :description
      t.integer    :state,     null: :false, default: 0
      t.date       :deleted_at

      t.timestamps

      t.index :permalink, unique: true
      t.index :state
    end
  end
end
