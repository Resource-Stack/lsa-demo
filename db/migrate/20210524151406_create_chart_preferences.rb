class CreateChartPreferences < ActiveRecord::Migration[5.2]
  def change
    create_table :chart_preferences do |t|
      t.string :table_name
      t.boolean :hide_table
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
