class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers
  has_and_belongs_to_many :groups
  accepts_nested_attributes_for :answers
  validates :name, presence: true
end
