class Course < ActiveRecord::Base
  belongs_to :user
  has_many :quizzes, dependent: :destroy
	validates :name, presence: true	
end
