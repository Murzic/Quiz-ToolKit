class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    @scanned_quiz = scanned_quiz

    qr = read_qr()

    if qr.at(0).is_a? ZBar::Symbol
      copy_id = qr.at(0).data.gsub(/\+\d*/, '')
      @page_nr = qr.at(0).data.gsub(/\d+\+/, '')
      # puts copy_id
      # puts page_nr
      @coordinates = Copy.find(copy_id).squares_xy
      # puts scanned_quiz.scan.path
      # puts copy.squares_xy
    end

    marker_processing()


    
    # puts "teststring!!!"
    
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

  def marker_processing()
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

  
    
      dpi_ratio = (tl["x"].max-tl["x"].min)/20.0
      puts "The dpi_ratio is: #{dpi_ratio}"
      tl_coord = [tl["x"].min+(tl["x"].max-tl["x"].min)/2.0, tl["y"].min+(tl["y"].max-tl["y"].min)/2.0]
      p "Top-left coordinate: #{tl_coord}"
      bl_coord = [bl["x"].min+(bl["x"].max-bl["x"].min)/2.0, bl["y"].min+(bl["y"].max-bl["y"].min)/2.0]
      p "Bottom-left coordinate: #{bl_coord}"

      rads = rotation_detection(tl_coord, bl_coord)

      prev_y = 0
      current_page = 1
      @coordinates.each do |qid, ahash|
        ahash.each do |aid, carray|
          current_page += 1 if carray[1] < prev_y
          if current_page == @page_nr.to_i
            

          prev_y = carray[1]
        end
      end



    rescue Exception => e
      puts e.message
    end

  end


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


  # def find_line_pixels(pixels, x_range, y_range)
  #   array = Array.new
  #   gray_range = (0..100)
  #   x_range.each do |i| 
  #     y_range.to_a.reverse.each do |j|
  #       r,g,b = ChunkyPNG::Color.to_truecolor_bytes(pixels[i, j])
  #       if gray_range === r && gray_range === g && gray_range === b
  #         if r == g && r == b
  #           array << i << j
  #           break
  #         end
  #       end
  #     end
  #   end
  #   array
  # end
end
