class QuizPdf < Prawn::Document
  def initialize(genquiz)
    super()
    @genquiz = genquiz
    @quiz = Quiz.find(genquiz.quiz_id)
    @questions = @quiz.questions.all
    quiz_questions
  end

  def quiz_questions
    @genquiz.copies.each do |copy|
      set_header(copy)
      set_questions(copy)   
      start_new_page
    end
  end

  def set_header(copy)
    student_group = StudentGroup.find(copy.student_group_id)
    student = Student.find(copy.student_id)
    text "#{@quiz.name}"
    text "#{student_group.name}"
    text "#{student.name} #{student.surname}" 
  end

  def set_questions(copy)
    questions = @questions.find(copy.questions)
    questions.each do |question|
      text "#{question.name}"
      question.answers.each do |answer|
        text "#{answer.name}"
      end
    end
  end


end