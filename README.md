# README
-----------
## Installation and running


* Install ruby 2.2.0 and rails 4.2.0

* Clone the repository

* CD into the cloned repository and Run `bundle install`, then `rake db:migrate` and `rake db:seed`

* Then run the server with `rails s` 

* In another terminal window, run `redis start` and then `QUEUE=* rake environment resque:work`. (This will make the resque queueing background to process the images when they are uploaded)

* You can now access the application at [localhost:3000](http://localhost:3000)


