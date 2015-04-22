class AddAttachmentImageToScannedQuizzes < ActiveRecord::Migration
  def self.up
    change_table :scanned_quizzes do |t|
      t.attachment :scan
    end
  end

  def self.down
    remove_attachment :scanned_quizzes, :scan
  end
end
