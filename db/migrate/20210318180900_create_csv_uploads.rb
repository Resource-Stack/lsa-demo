class CreateCsvUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :csv_uploads do |t|
      t.integer :user_id
      t.integer :source_id
      t.integer :policy_id
      t.integer :forescout_id
      t.boolean :flagged
      t.boolean :uploaded, default: false 
      t.boolean :uploaded_to_superior, default: false
      t.integer :uploaded_from

      t.timestamps
    end
  end
end
