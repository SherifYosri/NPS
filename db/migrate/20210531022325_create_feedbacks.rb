class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.binary :respondent_id, limit: 16, null: false, foreign_key: true
      t.binary :object_id, limit: 16, null: false, foreign_key: true
      t.integer :score, limit: 1
      t.string :touchpoint
      t.string :respondent_class
      t.string :object_class

      t.timestamps
    end

    add_index :feedbacks, [:respondent_id, :object_id, :touchpoint], unique: true
  end
end
