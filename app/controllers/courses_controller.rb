class CoursesController < ApplicationController
	before_action :authenticate_user!
	def index
		@user = current_user
		@courses = Course.all
	end

	def new
		@course = Course.new
	end

	def create
		@course = Course.new(course_params)

		if @course.save
			redirect_to user_courses_path	
		else
			render 'new'
		end
	end

	def edit
		@course = Course.find(params[:id])
	end

	def show
		@user = current_user
		@course = Course.find(params[:id])
		@quizzes = @course.quizzes.all
	end

	def update
		@course = Course.find(params[:id])
		@user = current_user
		if @course.update(course_params)
			redirect_to user_courses_path(@user)
		else
			render 'edit'
		end
	end

	def destroy
		@course = Course.find(params[:id])
		@user = current_user
		@course.destroy
		redirect_to user_courses_path(@user)
	end


	private

	def course_params
		params.require(:course).permit(:name)
	end
end
