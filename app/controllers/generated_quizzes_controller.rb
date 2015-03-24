class GeneratedQuizzesController < ApplicationController
  def create
    @user = current_user
    @generated_quiz = @user.generated_quizzes.new(generated_quiz_params)
    if @generated_quiz.save
      @quiz = Quiz.find(@generated_quiz.quiz_id)
      @question_ids = @quiz.question_ids
      @generated_quiz.copies.create(questions: @question_ids)
    end
    redirect_to :back
  end


  private
  def generated_quiz_params
    params.require(:generated_quiz).permit(:course_id, :quiz_id, :nr_of_copies)
  end
end
