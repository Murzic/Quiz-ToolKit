class CoursesController < ApplicationController

	def index
		@user = current_user
		@courses = @user.courses.all
		@course = Course.new
	end

	def new
		@user = current_user
		@course = @user.courses.new
	end

	def create
		@user = current_user
		@course = @user.courses.new(course_params)
		if @course.save
			redirect_to user_courses_path
		else
			@courses = @user.courses.all
			render :index
		end
	end

	def edit
		@course = Course.find(params[:id])
		@user = current_user
		@courses = @user.courses.all
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
			@courses = @user.courses.all
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
