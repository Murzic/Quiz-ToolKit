class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :groups
  validates :name, presence: true

  has_attached_file :image, styles: {thumb: "100x100", medium: "300x300"}, :default_url => "/images/:style/missing.png"
  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: /\Aimage/
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
  validates_attachment_size :image, less_than: 100.kilobytes
end
