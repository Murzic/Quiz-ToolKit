class Student < ActiveRecord::Base
	validates :name, :surname, presence: true
  belongs_to :student_group
  has_many :copies
end
