class GeneratedQuizzesController < ApplicationController
  def create
    @user = current_user
    @generated_quiz = @user.generated_quizzes.new(generated_quiz_params)
    @generated_quiz.save
    GeneratedQuizzesHelper.gen_copies(@generated_quiz)

    # Generate pdf document
    pdf = Prawn::Document.new
    send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
  

    # redirect_to :back
  end

  private
  def generated_quiz_params
    params.require(:generated_quiz).permit!
  end
end
