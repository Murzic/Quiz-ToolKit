class Question < ActiveRecord::Base
  belongs_to :quiz
  has_and_belongs_to_many :groups
end
