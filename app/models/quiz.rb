class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions
	validates :name, presence: true
end
