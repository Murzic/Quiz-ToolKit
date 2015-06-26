class QuestionsController < ApplicationController
  def edit
    @question = Question.find(params[:id]) # Question to be edited
    @answers = @question.answers.all
    @groups = @question.groups.all
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
    @quiz = Quiz.find(params["quiz_id"])
    @question = @quiz.questions.new(question_params)
    if @question.save
      redirect_to edit_question_path(@question)
    else
      redirect_to edit_question_path(@question)
    end
  end

  def update
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    if @question.update(question_params)
      redirect_to edit_question_path(@question)
    else
      redirect_to edit_question_path(@question)     
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    @question.destroy
    redirect_to :back
  end

  private

  def question_params
    begin
      params.require(:question).permit(:name, :image)
    rescue
      Hash.new
    end
  end
end
