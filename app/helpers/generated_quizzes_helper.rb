module GeneratedQuizzesHelper
  def self.gen_copies(genquiz)
    @attributes = genquiz.attributes.except("created_at", "updated_at")
    questions = Quiz.find(@attributes["quiz_id"]).question_ids
    if @attributes["copies_nr"]
      genquiz.copies.create(questions: questions, samples_nr: @attributes["copies_nr"])
    end
  end
end
