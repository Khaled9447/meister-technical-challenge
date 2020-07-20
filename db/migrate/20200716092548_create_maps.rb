class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.string :description
      t.boolean :public, default: false, index: true

      t.belongs_to :topic
      t.belongs_to :user

      t.timestamps
    end
  end
end
