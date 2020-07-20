class CreateMapPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :map_permissions do |t|
      t.integer :access_level, index: true
      
      t.belongs_to :user
      t.belongs_to :map

      t.timestamps
    end
  end
end
