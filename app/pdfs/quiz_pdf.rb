
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
      # stroke_axis
      qr = RQRCode::QRCode.new("#{copy.id}", size: 1, level: :h).to_img
      qr.resize(50, 50).save("app/pdfs/qrcodes/#{copy.id}.png")
      set_header(copy)
      set_questions(copy)   
      start_new_page
    end
  end

  def set_header(copy)
    if copy.student_group_id
      student_group = StudentGroup.find(copy.student_group_id)
      student = Student.find(copy.student_id)
      text "#{student.name} #{student.surname}", align: :right, size: 12
      text "#{student_group.name}", align: :right, size: 12
    end
    image "app/pdfs/qrcodes/#{copy.id}.png", at: [-25, 735]
    text "#{@quiz.name}", align: :center, size: 16
    move_down 20
  end

  def set_questions(copy)
    questions = @questions.find(copy.questions)
    questions_ordered = copy.questions.map do |id| 
      questions.detect do |each|
        each.id == id
      end
    end
    i = 0
    questions_ordered.each do |question|
      if cursor < 100 
        start_new_page
      end
      if cursor == 720
        set_header(copy)
      end
      span(500, position: :center) do
        range = ('a'..'z').to_a.reverse
        text "#{i+=1}. #{question.name}", inline_format: true
        question.answers.each do |answer|
          indent(15) do
            text "#{range.pop}. #{answer.name}", inline_format: true
          end
        end
        move_down 5
        # transparent(0.5) { stroke_bounds }
      end
    end
  end


end