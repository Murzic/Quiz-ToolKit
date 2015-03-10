class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions, dependent: :destroy
  has_many :groups, dependent: :destroy
	validates :name, presence: true
end
