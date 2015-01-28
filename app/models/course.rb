class Course < ActiveRecord::Base
  belongs_to :user
  has_many :quizzes
	validates :name, presence: true	
end
