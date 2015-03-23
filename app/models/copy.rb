class Copy < ActiveRecord::Base
  belongs_to :generated_quiz

  serialize :questions
  serialize :answers
end
