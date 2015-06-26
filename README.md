Quiz ToolKit
============
A web application which allows to:
* Manage quizzes
* Generate quizzes for printing 
* Evaluate completed quizzes

Installation and running
------------------------------

1. Install ruby 2.2.0 and rails 4.2.0

2. Clone the repository

3. CD into the cloned repository and run 

        $ bundle install
        $ rake db:migrate
        $ rake db:seed

4. Run the server with `rails s` 
5. In another terminal window, run 

        $ redis start 
        $ QUEUE=* rake environment resque:work
(This will make the resque queueing background to process the images when they are uploaded)
6. You can now access the application at [localhost:3000](http://localhost:3000)

Usage
--------------
In QuizToolKit you can add, remove and edit courses and their quizzes.
![](/public/screenshots/1.png)
When you access a quiz, you will get the list of questions that it has. Answers and question groups can be added to each question.
![](/public/screenshots/3.png)
Groups of students can be created, which will be used to generate quizzes for specific students and then grade them accordingly 
![](/public/screenshots/2.png)
A list of options is provided when generating a quiz. 
![](/public/screenshots/5.png)

An exmaple of a generated quiz page:
![](/public/screenshots/generated_quiz.JPG)

Todo
------------
1. Write tests
2. Take into account scanning imperfections when processing the scanned image
3. Statistics


