class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :title, index: true
      t.integer :level, index: true
      t.integer :parent_id

      t.timestamps
    end
  end
end
