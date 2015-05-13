class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    
    qr = read_qr(scanned_quiz)

    if qr.at(0).is_a? ZBar::Symbol
      copy_id = qr.at(0).data.gsub(/\+\d*/, '')
      page_nr = qr.at(0).data.gsub(/\d+\+/, '')
      # puts copy_id
      # puts page_nr
      copy = Copy.find(copy_id)
      # puts scanned_quiz.scan.path
      # puts copy.squares_xy
    end

    line = find_marker(scanned_quiz)

    unless line.empty? 

    
    # puts "teststring!!!"
    puts line
    # begin
    #   puts qr.at(0).data
    # rescue NoMethodError
    #   puts "rescued!!!"
    # end
  end

  def read_qr(scanned_quiz)
    image = MiniMagick::Image.open(scanned_quiz.scan.path)
    width_c = image.width / 612.0
    heigth_c = image.height / 792.0
    image.crop "#{60*width_c}x#{60*heigth_c}+#{10*width_c}+#{heigth_c*20}"
    image.format "jpg"
    image.write "public/system/qrcodes/#{scanned_quiz.id}.jpg"
    qr = ZBar::Image.from_jpeg(File.read("public/system/qrcodes/#{scanned_quiz.id}.jpg")).process
  end

  def find_marker(scanned_quiz)
    begin
      png = ChunkyPNG::Image.from_file(scanned_quiz.scan.path); nil
      array = Array.new
      (0..200).each do |i| 
        (620..791).to_a.reverse.each do |j|
          if ChunkyPNG::Color.to_hex(png[i, j])[1,6] != "ffffff"
            array << i << j
            break
          end
        end
      end

      unless array.empty?
        u1 = array[-2]
        u2 = array[-1]
        v1 = u1
        v2 = array.second
        cosalpha = (u1*v1 + u2*v2).abs/(Math.sqrt(u1**2 + u2**2) * Math.sqrt(v1**2 + v2**2))
        degrees = Math.acos(cosalpha)*180/Math::PI
        image = MiniMagick::Image.new(scanned_quiz.scan.path)
        if u2 > v2
          image.rotate "#{degrees}"
        elsif u2 < v2
          image.rotate "-#{degrees}"
        end
      else 
        raise "Marker not found!" 
      end



    rescue Exception => e
      puts e.message
    end
    array
  end
end
