class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    @scanned_quiz = scanned_quiz

    qr = read_qr()

    if qr.at(0).is_a? ZBar::Symbol
      copy_id = qr.at(0).data.gsub(/\+\d*/, '')
      page_nr = qr.at(0).data.gsub(/\d+\+/, '')
      # puts copy_id
      # puts page_nr
      copy = Copy.find(copy_id)
      # puts scanned_quiz.scan.path
      # puts copy.squares_xy
    end

    circle = left_top_marker()


    
    # puts "teststring!!!"
    p circle
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

  def left_top_marker()
    begin
      puts "Searching for top left marker.."
      png = ChunkyPNG::Image.from_file(@scanned_quiz.scan.path); nil
      h = png.height
      w = png.width

      marker = Hash["x" => Array.new, "y" => Array.new]
      black = false 
      (40*w/612).times.each do |x|
        (40*h/792).times.each do |y|
          if ChunkyPNG::Color.to_hex(png[x, y], false)[1,6] == "000000"
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




    rescue Exception => e
      puts e.message
    end
    marker
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
end
