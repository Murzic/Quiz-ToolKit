class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :question, index: true

      t.timestamps null: false
    end
    add_foreign_key :groups, :questions
  end
end
