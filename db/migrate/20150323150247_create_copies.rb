class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.text :questions # Hash
      t.text :answers # Hash
      t.integer :student_id
      t.integer :student_group_id
      t.integer :samples_nr

      t.references :generated_quiz, index: true

      t.timestamps null: false
    end
    add_foreign_key :copies, :generated_quizzes
  end
end
