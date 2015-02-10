class QuestionsController < ApplicationController
	def edit
		@question = Question.find(params[:id])
		@answers = @question.answers.all
		@quiz = @question.quiz
		@questions = @quiz.questions.all
		@course = @quiz.course
	end

	def new
		@quiz = Quiz.find(params[:quiz_id])
		@question = @quiz.questions.new
		@course = @quiz.course
	end

	def create
		@quiz = Quiz.find(params[:quiz_id])
		@question = @quiz.questions.new(question_params)
		if @question.save
		 	redirect_to edit_question_path(@question)
		else
		 	redirect_to new_quiz_question_path(@quiz)
		end
	end

	def update
		@question = Question.find(params[:id])
		@quiz = @question.quiz
		if @question.update(question_params)
			redirect_to edit_question_path(@question)
		else
			render 'edit'
		end
	end

	private

	def question_params
		params.require(:question).permit(:name, answers_attributes: [:id, :name, :correct])
	end
end
