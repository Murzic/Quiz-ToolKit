class CreateGeneratedQuizzes < ActiveRecord::Migration
  def change
    create_table :generated_quizzes do |t|
      t.integer :course_id
      t.integer :quiz_id
      t.integer :nr_of_copies
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :generated_quizzes, :users
  end
end
