class CreateTableEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :table_entries do |t|
      t.string :field_one
      t.string :field_two
      t.string :field_three
      t.string :field_four
      t.string :field_five
      t.string :field_six
      t.string :field_seven
      t.string :field_eight
      t.string :field_nine
      t.string :field_ten

      t.timestamps
    end
  end
end
