class CreateReportValues < ActiveRecord::Migration[5.2]
  def change
    create_table :report_values do |t|
      t.string :title
      t.integer :report_type_id

      t.timestamps
    end
  end
end
