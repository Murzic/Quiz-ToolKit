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
![](/public/screenshots/1.PNG)
When you access a quiz, you will get the list of questions that it has. Answers and question groups can be added to each question.
![](/public/screenshots/3.PNG)
Groups of students can be created, which will be used to generate quizzes for specific students and then grade them accordingly 
![](/public/screenshots/2.PNG)
A list of options is provided when generating a quiz. 
![](/public/screenshots/5.PNG)
In the "Generate Quizzes" tab we can see the student grades for specific quizzes.
![](/public/screenshots/6.PNG)

An example of a generated quiz page:
![](/public/screenshots/generated_quiz.JPG)

Todo
------------
1. Write tests
2. Take into account scanning imperfections when processing the scanned image
3. Statistics

License
---------
See [LICENSE](https://github.com/Murzic/Quiz-ToolKit/blob/master/LICENSE.md)
