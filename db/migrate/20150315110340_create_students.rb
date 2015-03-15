class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :surname
      t.references :student_group, index: true

      t.timestamps null: false
    end
    add_foreign_key :students, :student_groups
  end
end
