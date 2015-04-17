class GeneratedQuizzesController < ApplicationController
  def index
    @user = current_user
    @generated_quizzes = @user.generated_quizzes.all
    @courses = @user.courses
  end

  def show
    @generated_quiz = GeneratedQuiz.find(params[:id])
    @quiz = Quiz.find(@generated_quiz.quiz_id)
  end

  def create
    @user = current_user
    @generated_quiz = @user.generated_quizzes.new(generated_quiz_params)
    @generated_quiz.save
    GeneratedQuizzesHelper.gen_copies(@generated_quiz)

    # Generate pdf document
    pdf = QuizPdf.new(@generated_quiz)
    send_data pdf.render, filename: 'report.pdf', type: 'application/pdf', disposition: 'inline'
  

    # redirect_to :back
  end

  private
  def generated_quiz_params
    params.require(:generated_quiz).permit!
  end
end
