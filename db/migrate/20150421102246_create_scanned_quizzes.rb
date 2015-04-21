class CreateScannedQuizzes < ActiveRecord::Migration
  def change
    create_table :scanned_quizzes do |t|
      t.references :generated_quiz, index: true

      t.timestamps null: false
    end
    add_foreign_key :scanned_quizzes, :generated_quizzs
  end
end
