class CreateDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :deals do |t|
      t.binary :respondent_id, limit: 16, null: false, foreign_key: true
      t.binary :object_id, limit: 16, null: false, foreign_key: true
      t.string :feedback_token

      t.timestamps
    end
    
    add_index :deals, :feedback_token, unique: true
  end
end
