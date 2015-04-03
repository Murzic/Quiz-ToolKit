class GroupsController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @quiz = @question.quiz
    @quiz_groups = @quiz.groups
    if @quiz_groups.exists?(group_params)
      if !@question.groups.exists?(group_params)
        @question.groups << @quiz_groups.where(group_params)
      end
    else
      ActiveRecord::Base.transaction do
        @quiz_groups.create(group_params)
        @question.groups << @quiz_groups.where(group_params)
      end
    end
    redirect_to edit_question_path(@question) 
  end

  def destroy
    @question = Question.find(params[:question_id])
    @quiz = @question.quiz
    @group = Group.find(params[:id])
    ActiveRecord::Base.transaction do
      @question.groups.destroy(@group)
      if @group.questions.count.zero?
        @quiz.groups.destroy(@group)
      end
    end
    redirect_to edit_question_path(@question) 
  end
  

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
