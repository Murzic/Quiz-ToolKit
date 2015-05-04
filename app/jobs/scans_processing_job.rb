class ScansProcessingJob < ActiveJob::Base
  queue_as :urgent

  def perform(scanned_quiz)
    image = MiniMagick::Image.open(scanned_quiz.scan.path)
    width_c = image.width / 612.0
    heigth_c = image.height / 792.0
    image.crop "#{60*width_c}x#{60*heigth_c}+#{10*width_c}+#{heigth_c*20}"
    image.format "jpg"
    image.write "public/system/qrcodes/#{scanned_quiz.id}.jpg"
    # qr = Qrio::Qr.load("public/system/qrcodes/#{scanned_quiz.id}.jpg").qr.text
    qr = ZBar::Image.from_jpeg(File.read("public/system/qrcodes/#{scanned_quiz.id}.jpg")).process
    begin
      puts qr.at(0).data
    rescue NoMethodError
      puts "rescued!!!"
    end
  end
end
