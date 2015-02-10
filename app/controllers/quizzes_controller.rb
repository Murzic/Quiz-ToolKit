class QuizzesController < ApplicationController
	def create
		@course = Course.find(params[:course_id])
		@quiz = @course.quizzes.create(quiz_params)
		redirect_to course_path(@course)
	end

	def show
		@quiz = Quiz.find(params[:id])
		@questions = @quiz.questions.all
		@course = @quiz.course
	end

	def edit
		@quiz = Quiz.find(params[:id])
		@course = @quiz.course
		@quizzes = @course.quizzes.all
	end

	def update
		@quiz = Quiz.find(params[:id])
		@course = @quiz.course
		if @quiz.update(quiz_params)
			redirect_to course_path(@course)
		else
			render 'edit'
		end
	end

	def destroy
		# @course = Course.find(params[:course_id])
		# @quiz = @course.quizzes.find(params[:id])
		@quiz = Quiz.find(params[:id])
		@course = @quiz.course
		@quiz.destroy
		redirect_to course_path(@course)
	end
	
	private
	def quiz_params
		params.require(:quiz).permit(:name)
	end
end
