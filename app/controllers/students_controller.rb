class StudentsController < ApplicationController
  def edit
  end

  def create
    @student_group = StudentGroup.find(params[:student_group_id])
    @student = @student_group.students.build(student_params)
    @student.save
    redirect_to @student_group
  end

  def destroy
    @student = Student.find(params[:id])
    @student_group = @student.student_group
    @student.destroy
    redirect_to @student_group
  end

  private

  def student_params
    params.require(:student).permit(:name, :surname)
  end
end
