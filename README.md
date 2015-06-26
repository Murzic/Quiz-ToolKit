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
In QuizToolKit you can create courses which will contain your quizzes. 
![](/public/screenshots/1.png)
![](/public/screenshots/2.png)

![](/public/screenshots/5.png)

Todo
------------
1. Write tests
2. Take into account scanning imperfections when processing the scanned image



