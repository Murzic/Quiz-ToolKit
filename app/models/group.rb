class Group < ActiveRecord::Base
  has_and_belongs_to_many :questions
  belongs_to :quiz
end
