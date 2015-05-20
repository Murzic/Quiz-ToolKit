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
      @square_coordinates = Hash.new
      @page = 1
      set_header copy
      set_questions(copy)   
      start_new_page
      copy.squares_xy = @square_coordinates
      copy.save
    end
  end

  def set_header(copy)
    if copy.student_group_id
      student_group = StudentGroup.find(copy.student_group_id)
      student = Student.find(copy.student_id)
      text "#{student.name} #{student.surname}", align: :right, size: 12
      text "#{student_group.name}", align: :right, size: 12
    else
      move_down 24
    end
    # dash([1,2,3,2,1,5])
    # stroke_axis
    # stroke_horizontal_line -10, 100, at: -10
    # stroke_vertical_line -10, 100, at: -10
    stroke do
      circle [-10, 730], 10
      line [-10, 735], [-10,725]
      line [-15, 730], [-5, 730]
      circle [-10, -10], 10
      circle [550, -10], 10
      circle [550, 730], 10
    end
    # undash
    # qr = RQRCode::QRCode.new("#{copy.id}+#{@page}", size: 1, level: :h).to_img
    # qr.resize(50, 50).save("#{Rails.root}/app/pdfs/qrcodes/#{copy.id}-#{@page}.png")
    # Pngqr.encode "#{copy.id}+#{@page}", size: 2, border: 1, scale: 2, file: "#{Rails.root}/app/pdfs/qrcodes/#{copy.id}-#{@page}.png"
    Strokes::Barcode.new(:qrcode, "#{copy.id}+#{@page}").save("#{Rails.root}/app/pdfs/qrcodes/#{copy.id}-#{@page}.png", width: 60)
    image "app/pdfs/qrcodes/#{copy.id}-#{@page}.png", at: [10, 735]
    text "#{@quiz.name}", align: :center, size: 16
    move_down 20
    draw_text! "#{@page}", at: [550, 5]
    @page += 1
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
      @square_coordinates[question.id] = Hash.new
      range = ('a'..'z').to_a.reverse
      if cursor < 30
        start_new_page
      end
      if cursor == 720
        set_header(copy)
      end
      span(500, position: :center) do
        text "#{i+=1}. #{question.name}", inline_format: true
      end
      question.answers.each do |answer|
        if cursor < 30
          start_new_page
        end
        if cursor == 720
          set_header(copy)
        end
        # stroke_bounds
        span(500, position: :center) do
          puts "bot: #{bounds.absolute_bottom}"
          puts "top: #{bounds.absolute_top}"
          puts "corrected: #{756-26-bounds.absolute_bottom+36}"
          puts "left: #{bounds.absolute_left}"

          @square_coordinates[question.id][answer.id] = [bounds.absolute_left-26, 756-26-bounds.absolute_bottom+36]
          stroke do
            rectangle [bounds.left, cursor], 9, 9
          end
          indent(15) do
            text "#{range.pop}. #{answer.name}", inline_format: true
          end
        end
      # transparent(0.5) { stroke_bounds }

      end
      move_down 5
    end

  end


end