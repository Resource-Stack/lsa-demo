class CreateElasticReports < ActiveRecord::Migration[5.2]
  def change
    create_table :elastic_reports do |t|
      t.string :report_type_title
      t.string :report_value_title
      t.string :elastic_id
      t.references :source

      t.timestamps
    end
  end
end
