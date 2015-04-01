# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ActiveRecord::Base.transaction do
  user = User.create email: "user@example.com", password: "userexample",password_confirmation: "userexample"
  course = user.courses.create(name: "QC")
  quiz = course.quizzes.create(name: "Quiz nr. 1")
  range = 1..30
  range2 = 1..4
  array = Array.new
  range.each do |n|
    array << {name: "Question nr #{n}"}
  end

  quiz.groups.create([{name: "default"}, {name: "easy"}, {name: "medium"}, {name: "hard"}])

  quiz.questions.create(array) # Creates the questions
  quiz.questions.each do |question| # Creates the answers for each question
    array2 = Array.new
    range2.each do |n|
      if rand(4) == 0
        array2 << {name: "Answer nr #{n}", correct: true}
      else
        array2 << {name: "Answer nr #{n}"}
      end
    end  
    question.answers.create(array2)
    question.groups << quiz.groups.where(name: "default")
    case question.id
    when 1..10
      question.groups << quiz.groups.where(name: "easy")
    when 11..20
      question.groups << quiz.groups.where(name: "medium")
    when 21..30
      question.groups << quiz.groups.where(name: "hard")  
    end
  end

  student_group = course.student_groups.create(name: "FAF111")
  student_group.students.create([
                                {name: "Eugeniu", surname: "Ungureanu"},
                                {name: "Sergiu", surname: "Terman"},
                                {name: "Mihai", surname: "Iachimovschi"},
                                {name: "Vladimir", surname: "Tribusean"},
                                {name: "Vasile", surname: "Mardari"},
                                {name: "Ion", surname: "Marusic"},
                                {surname: "Negrei", name: "Petru"},
                                {surname: "Plesco", name: "Alexandra"},
                                {surname: "Truhin", name: "Alexei"},
                                {surname: "Rusu", name: "Dorin"},
                                {surname: "Safeaniuc", name: "Alexandru"}])
end