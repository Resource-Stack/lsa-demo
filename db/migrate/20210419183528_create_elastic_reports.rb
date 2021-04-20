class CreateElasticReports < ActiveRecord::Migration[5.2]
  def change
    create_table :elastic_reports do |t|
      t.integer :report_type_id
      t.integer :report_value_id

      t.timestamps
    end
  end
end
