class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.text :questions
      t.text :answers
      t.integer :student_id
      t.integer :student_group_id
      t.references :generated_quiz, index: true

      t.timestamps null: false
    end
    add_foreign_key :copies, :generated_quizzes
  end
end
