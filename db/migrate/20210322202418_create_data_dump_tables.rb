class CreateDataDumpTables < ActiveRecord::Migration[5.2]
  def change
    create_table :data_dump_tables do |t|
      t.integer :data_dump_dictionary_id
      t.string :csv_header_name
      t.string :csv_row_value

      t.timestamps
    end
  end
end
