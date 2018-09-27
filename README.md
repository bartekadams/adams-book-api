# README

API project in Ruby on Rails for book sharing. Frontend for this app is adams-book-web. [Working example should be here](http://80.211.241.181/).

* System dependencies

  May require ImageMagick installed in system to properly resize uploaded images (in Ubuntu 16.04 it does).
  
* Deployment instructions

  For now you have to change book_cover_uploader.rb asset_host url to make pictures work. (Not yet .env file)

* Fake data after seeding database are from Faker gem

```sh
bundle install

rails db:reset
```
