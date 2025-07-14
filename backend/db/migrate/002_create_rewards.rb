class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :cost, null: false
      
      t.timestamps
    end
    
    add_index :rewards, :name
  end
end