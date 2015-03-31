class GeneratedQuiz < ActiveRecord::Base
  serialize :student_group_ids
  serialize :question_groups_nrs
  
  belongs_to :user
  has_many :copies

  before_save :remove_hash_pairs, on: :create

  private
  def remove_hash_pairs
    self.question_groups_nrs.delete_if do |key, value|
      value.empty?
    end          
  end
end
