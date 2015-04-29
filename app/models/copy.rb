class Copy < ActiveRecord::Base
  belongs_to :generated_quiz


  serialize :questions
  serialize :answers
  serialize :squares_xy
end
