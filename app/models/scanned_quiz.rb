class ScannedQuiz < ActiveRecord::Base
  belongs_to :generated_quiz

  has_attached_file :image
  validates_attachment :image, presence: true,
    content_type: { content_type: "image/png" },
    size: { less_than: 200.kilobytes }
end
