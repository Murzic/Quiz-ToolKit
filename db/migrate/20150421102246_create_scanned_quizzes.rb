class CreateScannedQuizzes < ActiveRecord::Migration
  def change
    create_table :scanned_quizzes do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :scanned_quizzes, :users
  end
end
