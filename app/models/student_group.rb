class StudentGroup < ActiveRecord::Base
	validates :name, presence: true
	has_many :students, dependent: :destroy
	has_and_belongs_to_many :courses
end
