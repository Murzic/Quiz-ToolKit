class Course < ActiveRecord::Base
	has_many :quizzes
end
