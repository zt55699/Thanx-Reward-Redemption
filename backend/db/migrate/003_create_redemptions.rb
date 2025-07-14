class CreateRedemptions < ActiveRecord::Migration[8.0]
  def change
    create_table :redemptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      
      t.timestamps
    end
    
    # Composite index for fast user lookup and date sorting
    add_index :redemptions, [:user_id, :created_at]
  end
end