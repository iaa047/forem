class CreateForemUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :forem_users do |t|

      t.timestamps
    end
  end
end
