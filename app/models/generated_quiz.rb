class GeneratedQuiz < ActiveRecord::Base
  belongs_to :user
  has_many :copies
end
