class CreateDataDumpDictionaries < ActiveRecord::Migration[5.2]
  def change
    create_table :data_dump_dictionaries do |t|
      t.integer :user_id
      t.integer :source_id
      t.string :csv_header_name

      t.timestamps
    end
  end
end
