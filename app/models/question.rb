class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :groups
  validates :name, presence: true
end
