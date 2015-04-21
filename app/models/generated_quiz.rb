class GeneratedQuiz < ActiveRecord::Base
  serialize :student_group_ids
  serialize :question_groups_nrs
  
  belongs_to :user
  has_many :copies

  before_create :remove_hash_pairs, on: :create

  private
  ### The fields_for in the modal's form will pass key/value pairs even if the value isn't specified
  ### The method removes the passed hash's pairs if they don't have a value       
  def remove_hash_pairs
    self.question_groups_nrs.delete_if do |key, value|
      value.empty?
    end          
  end
end
