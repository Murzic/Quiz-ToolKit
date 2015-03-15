class StudentGroupsController < ApplicationController
  def index
  	@student_groups = StudentGroup.all
  end

  def create
  	@student_group = StudentGroup.new(student_group_params)
  	@student_group.save
  	redirect_to student_groups_path
  end

  def show
  end

  def update
  	@student_group = StudentGroup.find(params[:id])
  	if @student_group.update(student_group_params)
  		redirect_to student_groups_path
  	else
  		render 'edit'
  	end
  end

  def edit
  	@student_group = StudentGroup.find(params[:id])
  	@student_groups = StudentGroup.all
  end

  def destroy
  	@student_group = StudentGroup.find(params[:id])
  	@student_group.destroy
  	redirect_to student_groups_path
  end

  private

  def student_group_params
  	params.require(:student_group).permit(:name)
  end
end
