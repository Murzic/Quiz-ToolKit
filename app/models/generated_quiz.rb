class GeneratedQuiz < ActiveRecord::Base
  serialize :student_group_ids
  serialize :question_grops_nrs
  
  belongs_to :user
  has_many :copies
end
