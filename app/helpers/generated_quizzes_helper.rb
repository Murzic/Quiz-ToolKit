module GeneratedQuizzesHelper
  def self.gen_copies(genquiz)
    @attributes = genquiz.attributes.except("created_at", "updated_at")
    questions = Quiz.find(@attributes["quiz_id"]).question_ids

    if @attributes["copies_nr"]
      if @attributes["random_opt"]
        @attributes["copies_nr"].times do
          genquiz.copies.create(questions: questions.shuffle, samples_nr: 1)
        end
      else
        genquiz.copies.create(questions: questions, samples_nr: @attributes["copies_nr"])
      end
    end
  
    if @attributes["student_group_ids"] && !@attributes["student_group_ids"].first.empty?
      array = Array.new
      @attributes["student_group_ids"].each do |sgid|
        StudentGroup.find(sgid).student_ids.each do |sid|
          array << {questions: questions, samples_nr: 1, student_id: sid, student_group_id: sgid}
        end
      end
      genquiz.copies.create(array)
    end

  end
end
