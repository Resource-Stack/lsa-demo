class CreateCsvUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :csv_uploads do |t|
      t.integer :source_id
      t.boolean :uploaded, default: false 
      t.date :csv_upload_date
      t.string :logstash_path
      t.string :logstash_column, array: true
      t.string :logstash_host
      t.string :logstash_index

      t.timestamps
    end
  end
end
