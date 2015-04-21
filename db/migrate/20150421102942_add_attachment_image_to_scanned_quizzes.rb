class AddAttachmentImageToScannedQuizzes < ActiveRecord::Migration
  def self.up
    change_table :scanned_quizzes do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :scanned_quizzes, :image
  end
end
