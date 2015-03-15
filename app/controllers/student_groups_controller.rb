class StudentGroupsController < ApplicationController
  def index
  	@student_groups = StudentGroup.all
  end

  def create
  	@student_group = StudentGroup.new(student_group_params)
  	@student_group.save
  	redirect_to student_groups_path
  end

  private

  def student_group_params
  	params.require(:student_group).permit(:name)
  end
end
