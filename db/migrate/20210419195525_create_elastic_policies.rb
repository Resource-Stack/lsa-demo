class CreateElasticPolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :elastic_policies do |t|
      t.string :title
      t.string :source, array: true
      t.json :policy_output
      t.json :input_requirements

      t.timestamps
    end
  end
end
