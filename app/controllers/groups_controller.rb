class GroupsController < ApplicationController
	def create
		@question = Question.find(params[:question_id])
		@quiz = @question.quiz
		@quiz_groups = @quiz.groups
		if @quiz_groups.exists?(group_params)
			@question.groups << @quiz_groups.where(group_params)
		else
			@quiz_groups.create(group_params)
			@question.groups << @quiz_groups.where(group_params)
		end
		redirect_to edit_question_path(@question)	
	end

	def update
		@group = Group.find(params[:id])
		@question = params[:question_id]
		@group.update(group_params)
		redirect_to edit_question_path(@question)
	end

	private

	def group_params
		params.require(:group).permit(:name)
	end
end
