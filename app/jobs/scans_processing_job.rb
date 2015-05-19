class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    @scanned_quiz = scanned_quiz
    @answers = Hash.new
    puts "Starting image processing.."
    qr = read_qr()

    if qr.at(0).is_a? ZBar::Symbol
      @copy_id = qr.at(0).data.gsub(/\+\d*/, '')
      @page_nr = qr.at(0).data.gsub(/\d+\+/, '')
      puts "Copy id: #{@copy_id}"
      puts "Page: #{@page_nr}"
      @coordinates = Copy.find(@copy_id).squares_xy
      # puts scanned_quiz.scan.path
      # puts copy.squares_xy
    end

    line = find_marker()


    
    p line
    # begin
    #   puts qr.at(0).data
    # rescue NoMethodError
    #   puts "rescued!!!"
    # end
  end

  def read_qr()
    puts "Reading QR code.."
    image = MiniMagick::Image.open(@scanned_quiz.scan.path)
    orig_format = image.type.downcase
    width_c = image.width / 612.0
    heigth_c = image.height / 792.0
    image.crop "#{100*width_c}x#{125*heigth_c}+#{10*width_c}+#{heigth_c*20}"
    image.format "pgm"
    image.write "public/system/qrcodes/#{@scanned_quiz.id}.pgm"
    if orig_format == "jpeg"
      image = MiniMagick::Image.new(@scanned_quiz.scan.path)
      image.format "png"
      puts "Image converted to png"
    end

    begin 
      qr = ZBar::Image.from_pgm(File.read("public/system/qrcodes/#{@scanned_quiz.id}.pgm")).process
    rescue Exception => e
      puts "The qr code wasn't processed. The error:"
      puts e.inspect
    end
  end

  def find_marker()
    begin
      puts "Searching for bottom line marker.."
      png = ChunkyPNG::Image.from_file(@scanned_quiz.scan.path.gsub(/[Jj][Pp][Gg]\z/, "png")); nil
      h = png.height
      w = png.width
      ppi_ratio = get_ppi()/72.0

      lp = find_line_pixels(png, 0..(175*w/612.0).round, h-(50*h/792.0).round..h-1)
    
      unless lp.empty?
        u1 = lp[-2]-lp[ppi_ratio*2]
        u2 = lp[-1]-lp[1+ppi_ratio.round*2]
        v1 = u1
        v2 = 0
        cosalpha = (u1*v1 + u2*v2).abs/(Math.sqrt(u1**2 + u2**2) * Math.sqrt(v1**2 + v2**2))
        degrees = Math.acos(cosalpha)*180/Math::PI
        radians = degrees*Math::PI/180
        puts "u1 = #{lp[-2]}-#{lp[0]}=#{u1}, u2 = #{lp[-1]}-#{lp[1+w/612*2]}=#{u2}, v1 = #{v1}, v2 = #{v2}"
        # puts cosalpha
        puts "The image is rotated by #{degrees} degrees!!"
        puts "Radians: #{radians}"
        puts "Searching for squares' pixels.."
        prev_y = 99999
        current_page = 1

        @coordinates.each do |question_id, answers_hash|
          answers_hash.each do |answer_id, coordinate_array|
            puts "test"
            puts coordinate_array[0]
            puts coordinate_array[1]
            if coordinate_array[1] > prev_y
              current_page += 1
            end
            square_pixels = Array.new
            begin
              if current_page == @page_nr.to_i
                puts @coordinates
                puts "Adding pixels to array.."
                ### TODO Must remove the 8's  !!!!

                (((coordinate_array[1])*ppi_ratio).round..((coordinate_array[1]+10)*ppi_ratio).round).to_a.reverse.each do |y|
                  (((coordinate_array[0]+10)*ppi_ratio).round..((coordinate_array[0]+20)*ppi_ratio).round).each do |x|
                    corrected_x = x * Math.cos(radians) - y * Math.sin(radians)
                    corrected_y = y * Math.cos(radians) + x * Math.sin(radians)
                    square_pixels << ChunkyPNG::Color.to_hex(png[corrected_x.round + lp[0], 
                      lp[1] - corrected_y.round], false)
                    print "(#{corrected_x.round+lp[0]},#{lp[1+ppi_ratio.round*2] - corrected_y.round})"
                  end
                end
              end
            rescue Exception => e
              puts e.message
              puts e.inspect
            end

            puts "Array length: #{square_pixels.length}"
            counter = Math.sqrt(square_pixels.length).round-1
            square_pixels.length.times do |i|
              if i == counter
                counter += Math.sqrt(square_pixels.length).round
                if square_pixels[i][1,6] != "ffffff"
                  print "1\n"
                else
                  print "0\n"
                end
              else
                if square_pixels[i][1,6] != "ffffff"
                  print "1 "
                else
                  print "0 "
                end
              end
            end

            prev_y = coordinate_array[1]
          end
        end




        # image = MiniMagick::Image.new(@scanned_quiz.scan.path.gsub(/[Jj][Pp][Gg]\z/, "png"))
        # if u2 < v2
        #   image.rotate "#{degrees}"
        #   puts "rotated right"
        # elsif u2 > v2
        #   image.rotate "-#{degrees}"
        #   puts "rotated left"
        # end
      else 
        raise "Marker not found!" 
      end

      puts "#{get_ppi()}"
      puts "PPI ratio: #{ppi_ratio}"
      puts "The image is rotated by #{degrees} degrees!!"
      puts "Radians: #{radians}"


    rescue Exception => e
      puts e.message
    end
    lp
  end

  def find_line_pixels(pixels, x_range, y_range)
    array = Array.new
    gray_range = (0..100)
    x_range.each do |i|
      y_range.to_a.reverse.each do |j|
        r,g,b = ChunkyPNG::Color.to_truecolor_bytes(pixels[i, j])
        if gray_range === r && gray_range === g && gray_range === b
          if r == g && r == b
            array << i << j
            break
          end
        end
      end
    end
    array
  end

  def get_ppi() # pixels per inch
    image = MiniMagick::Tool::Identify.new
    image.format("%x")
    image << @scanned_quiz.scan.path.gsub(/[Jj][Pp][Gg]\z/, "png")
    result = image.call
    if /inch/i =~ result || /undef/i =~ result
      ppi = image.call.gsub(/\s.+/, "").to_f.round.to_i
    elsif /centi/i =~ result
      ppc = image.call.gsub(/\s.+/, "")
      ppi = 2.54 * ppc.to_f
      ppi.round.to_i
    else
      false
    end
  end
end
