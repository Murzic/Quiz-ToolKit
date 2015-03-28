# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create email: "user@example.com", password: "userexample",password_confirmation: "userexample"
course = user.courses.create(name: "QC")
quiz = course.quizzes.create(name: "Quiz nr. 1")
range = 1..30
array = Array.new
range.each do |n|
  array << {name: "Question nr #{n}"}
end
quiz.questions.create(array)
student_group = course.student_groups.create(name: "FAF111")

