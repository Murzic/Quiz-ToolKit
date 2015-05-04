class ScannedQuiz < ActiveRecord::Base
  belongs_to :user

  after_commit do 
    ScansProcessingJob.perform_later self
  end    

  has_attached_file :scan, path: ':rails_root/public/system/:class/:attachment/:updated_at/:filename'
  validates_attachment :scan, presence: true,
    content_type: { content_type: "image/png" },
    size: { less_than: 200.kilobytes }
end
