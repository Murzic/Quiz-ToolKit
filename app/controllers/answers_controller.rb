class AnswersController < ApplicationController
	def update
		@answer = Answer.find(params[:id])
		@question = @answer.question
		@answer.update(answer_params)
		redirect_to edit_question_path(@question) 
	end

	def create
		@question = Question.find(params[:question_id])		
		@answer = @question.answers.create(answer_params)
		redirect_to :back
	end

	private

	def answer_params
		params.require(:answer).permit(:name, :correct)
	end
end
