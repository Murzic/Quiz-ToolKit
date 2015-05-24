class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    @scanned_quiz = scanned_quiz
    @answers = Array.new

    qr = read_qr()

    if qr.at(0).is_a? ZBar::Symbol
      copy_id = qr.at(0).data.gsub(/\+\d*/, '')
      @page_nr = qr.at(0).data.gsub(/\d+\+/, '')
      # puts copy_id
      # puts page_nr
      @copy = Copy.find(copy_id)
      @copy_answers = @copy.answers
      @coordinates = @copy.squares_xy
    else
      raise "QR code wasn't decoded!"
    end

    puts @coordinates

    answers_processing()

    if @answers
      puts "Saving checked answers"
      if @copy_answers
        @copy.answers = @copy_answers | @answers
      else
        @copy.answers = @answers
      end
      @copy.save
    end

    p @answers

    puts "#{quiz_marking}%"


    # puts "teststring!!!"
    
    # begin
    #   puts qr.at(0).data
    # rescue NoMethodError
    #   puts "rescued!!!"
    # end
  end


  ###############################################
  def read_qr()
    puts "Reading QR code.."
    image = MiniMagick::Image.open(@scanned_quiz.scan.path)
    orig_format = image.type.downcase
    width_c = image.width / 612.0
    heigth_c = image.height / 792.0
    image.crop "#{(150*width_c).round}x#{(100*heigth_c).round-1}+0+0"
    image.format "pgm"
    image.write "public/system/qrcodes/#{@scanned_quiz.id}.pgm"
    image = nil
    image = MiniMagick::Image.open(@scanned_quiz.scan.path)
    puts "Thresholding.."
    if orig_format == "jpeg"
      image.format "png"
      image.threshold "60%"
      image.write @scanned_quiz.scan.path
      puts "Image converted to png"
    elsif orig_format == "png"
      image.threshold "60%"
      image.write @scanned_quiz.scan.path
    end

    begin 
      qr = ZBar::Image.from_pgm(File.read("public/system/qrcodes/#{@scanned_quiz.id}.pgm")).process
    rescue Exception => e
      puts "The qr code wasn't processed. The error:"
      puts e.inspect
    end
  end

  ########################################################
  def quiz_marking
    puts "Starting quiz marking.."
    correct_answers = Array.new
    copy_answers = @copy.answers
    questions = Question.where(id: @copy.questions).includes(:answers).where(answers: { correct: true })
    questions.each do |q|
      correct_answers = correct_answers + q.answer_ids
    end

    ## Gets the correct chosen answers' ids
    correct_answered = correct_answers & copy_answers
    incorrect_answered = copy_answers - correct_answers

    puts "Answered: #{copy_answers.length}"
    p copy_answers
    puts "Correct answers: #{correct_answers.length}"
    p correct_answers
    puts "Correct answered: #{correct_answered.length}"
    p correct_answered
    puts "Incorrect answered: #{incorrect_answered.length}"
    p incorrect_answered
    mark = (correct_answered.length-incorrect_answered.length).fdiv(correct_answers.length)*100

    ## Updating mark field in copies table
    @copy.mark = mark
    @copy.save

    mark
  end

  ##############################################################
  def answers_processing()
    begin
      puts "Image loading.."
      png = ChunkyPNG::Image.from_file(@scanned_quiz.scan.path); nil
      h = png.height
      w = png.width

      x_dist = 80*w/612
      y_dist = 60*h/792

      puts "Searching for markers.."
      tl = find_marker(png, 0..x_dist, 0..y_dist) # top-left
      tr = find_marker(png, ((w-x_dist)..(w-1)).to_a.reverse, 0..y_dist) # top-right
      bl = find_marker(png, 0..x_dist, ((h-y_dist)..(h-1)).to_a.reverse)  # bot-left
      br = find_marker(png, ((w-x_dist)..(w-1)).to_a.reverse,
        ((h-y_dist)..(h-1)).to_a.reverse) # bot-right

  
    
      tl_coord = [(tl["x"].min+(tl["x"].max-tl["x"].min)/2.0).round, (tl["y"].min+(tl["y"].max-tl["y"].min)/2.0).round]
      p "Top-left coordinate: #{tl_coord}"
      bl_coord = [(bl["x"].min+(bl["x"].max-bl["x"].min)/2.0).round, (bl["y"].min+(bl["y"].max-bl["y"].min)/2.0).round]
      p "Bottom-left coordinate: #{bl_coord}"
      dpi_ratio = Math.sqrt((tl_coord[0]-bl_coord[0])**2+(tl_coord[1]-bl_coord[1])**2)/740
      puts "The dpi_ratio is: #{dpi_ratio}"

      rads = rotation_detection(tl_coord, bl_coord)

      prev_y = 0
      current_page = 1
      @coordinates.each do |qid, ahash|
        ahash.each do |aid, carray|
          square_pixels = Array.new
          current_page += 1 if carray[1] < prev_y
          if current_page == @page_nr.to_i
            ((carray[1]*dpi_ratio).round..((carray[1]+9)*dpi_ratio).round).each do |y|
              (((carray[0])*dpi_ratio).round..((carray[0]+9)*dpi_ratio).round).each do |x|
                corrected_x = x * Math.cos(-rads) - y * Math.sin(-rads)
                corrected_y = y * Math.cos(-rads) + x * Math.sin(-rads)
                square_pixels << ChunkyPNG::Color.to_hex(png[corrected_x.round + tl_coord[0], 
                      corrected_y.round + tl_coord[1]], false)
                # print "(#{corrected_x.round + tl_coord[0]},#{corrected_y.round + tl_coord[1]})"
              end
            end
          end

          puts "White pixels:"
          white_pixels = square_pixels.count "#ffffff"
          puts white_pixels
          puts "Black pixels:"
          black_pixels = square_pixels.count "#000000"
          puts black_pixels
          puts "B/W ratio:"
          bw_ratio = black_pixels.fdiv(white_pixels)
          puts bw_ratio

          ## Add the checked answered to array
          if bw_ratio > 1
            @answers << aid
          end


          # puts carray[0]
          # puts carray[1]
          # blablax = (carray[0]*dpi_ratio).round * Math.cos(-rads) - (carray[1]*dpi_ratio).round * Math.sin(-rads)
          # blablai = (carray[1]*dpi_ratio).round * Math.cos(-rads) + (carray[0]*dpi_ratio).round * Math.sin(-rads)
          # puts blablax.round
          # puts blablai.round

          # puts ((carray[0]*dpi_ratio).round + tl_coord[0])
          # puts ((carray[1]*dpi_ratio).round + tl_coord[1])

          # print_square(square_pixels)

          prev_y = carray[1]
        end
      end
    rescue Exception => e
      puts e.message
    end
  end


  ##################################################
  def find_marker(pixels, x_range, y_range)
    marker = Hash["x" => Array.new, "y" => Array.new]
    black = false 
    x_range.each do |x|
      y_range.each do |y|
        if ChunkyPNG::Color.to_hex(pixels[x, y], false)[1,6] == "000000"
          marker["x"] << x
          marker["y"] << y
          if black == false
            black = true
          end
        end
      end
      if black == true
        unless marker["x"].include? x
          break
        end
      end
    end
    if marker
      puts "Marker has been found"
    else 
      puts "Marker hasn't been not found"
    end
    marker
  end


  #####################################
  def rotation_detection(u, v)
    u1 = v[1] - u[1]
    u2 = 0
    v1 = u1
    v2 = v[0] - u[0]

    cosalpha = (u1*v1 + u2*v2).abs/(Math.sqrt(u1**2 + u2**2) * Math.sqrt(v1**2 + v2**2))
    degrees = Math.acos(cosalpha)*180/Math::PI
    if v2 < 0
      degrees = -degrees
    end
    puts "Image is rotated by #{degrees} degrees,"
    radians = degrees*Math::PI/180
    puts "or #{radians} radians."
    radians
  end


  ##########################################
  def print_square(sp)
    puts "Array length: #{sp.length}"
    counter = Math.sqrt(sp.length).round-1
    sp.length.times do |i|
      if i == counter
        counter += Math.sqrt(sp.length).round
        if sp[i][1,6] != "ffffff"
          print "1\n"
        else
          print "0\n"
        end
      else
        if sp[i][1,6] != "ffffff"
          print "1 "
        else
          print "0 "
        end
      end
    end
  end

end
