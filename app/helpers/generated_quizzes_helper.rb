module GeneratedQuizzesHelper
  def self.gen_copies(genquiz)
    @attributes = genquiz.attributes.except("created_at", "updated_at")
    questions = Quiz.find(@attributes["quiz_id"]).question_ids
    groups = Quiz.find(@attributes["quiz_id"]).group_ids

    ### The case when the "copies nr" option is given with or without the random option
    if @attributes["copies_nr"]
      if @attributes["random_opt"]
        @attributes["copies_nr"].times do
          genquiz.copies.create(questions: questions.shuffle, samples_nr: 1)
        end
      else
        genquiz.copies.create(questions: questions, samples_nr: @attributes["copies_nr"])
      end
    end
  
    ### One or more "Student groups" are selected and various options
    if @attributes["student_group_ids"] && !@attributes["student_group_ids"].first.empty?
      ques_nr = 0
      if @attributes["questions_nr"]
        ques_nr = @attributes["questions_nr"]
      else
        ques_nr = questions.length
      end
      if @attributes["random_opt"]
        ActiveRecord::Base.transaction do
          @attributes["student_group_ids"].each do |sgid|
            StudentGroup.find(sgid).student_ids.each do |sid|
              genquiz.copies.create(questions: questions.shuffle.first(ques_nr), samples_nr: 1, student_id: sid, student_group_id: sgid)
            end
          end
        end 
      else
        ActiveRecord::Base.transaction do
          @attributes["student_group_ids"].each do |sgid|
            StudentGroup.find(sgid).student_ids.each do |sid|
              genquiz.copies.create(questions: questions.first(ques_nr), samples_nr: 1, student_id: sid, student_group_id: sgid)
            end
          end
        end
      end
    end

  end
end
