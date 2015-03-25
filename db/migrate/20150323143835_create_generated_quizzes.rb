class CreateGeneratedQuizzes < ActiveRecord::Migration
  def change
    create_table :generated_quizzes do |t|
      t.integer :course_id
      t.integer :quiz_id
      t.integer :copies_nr
      t.boolean :random_opt
      t.text :student_group_ids # Array of ids
      t.integer :questions_nr
      t.integer :versions_nr
      t.text :question_groups_nrs # Hash containing group id and its nr

      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :generated_quizzes, :users
  end
end
