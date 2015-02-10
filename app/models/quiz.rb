class Quiz < ActiveRecord::Base
  belongs_to :course
  has_many :questions, dependent: :destroy
	validates :name, presence: true
end
