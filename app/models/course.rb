class Course < ActiveRecord::Base
  belongs_to :user
  has_many :quizzes, dependent: :destroy
  has_and_belongs_to_many :student_groups
	validates :name, presence: true, length: { in: 2..20 }	
end
