# SCUDERIA.COM

Building
[*scuderia.com*](http://scuderia.herokuapp.com/)
by [Ignacio Palladino](http://ignaciopalladino.com/).

== About the site

For a long time there has been a need for a place where Ferrari enthusiasts can trade their cars and be up to date with the most recent Ferrari news. Scuderia.com aims to take care if this as a whole, a complete portal to services and news.

This could me modified to work with any specific brands.


Starting dev on a new computer

1- Install heroku toolbelt

2- heroku git:clone -a scuderia

3- Add remote origin
git remote add origin git@github.com:ipalladino/scuderia.git

4- Install postgres db app

5- Add postgres path to bash profile
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

6- Export db from heroku
heroku pg:backups capture
curl -o latest.dump `heroku pgbackups:url --app=scuderia`

7- Import DB
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U ipalladino -d scuderia latest.dump

8- Install rvm

9- Install ruby 2.1.0 with binary disabled, otherwise it errors
rvm install 2.1.0 --disable-binary

10- rvm use rvm use ruby-2.1.0

11- run: heroku config
copy necessary vars onto .bash_profile or .bashrc


12- to expire ferraris run
heroku run rake expire_ferraris --trace
update this task in lib/tasks/scheduler.rake
