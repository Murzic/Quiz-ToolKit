class Copy < ActiveRecord::Base
  belongs_to :generated_quiz
  belongs_to :student

  serialize :questions
  serialize :answers
  serialize :squares_xy
end
