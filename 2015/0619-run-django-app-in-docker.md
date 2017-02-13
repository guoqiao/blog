Title: Run Django app in Docker

## Conditions
I work on Ubuntu:14.04 64bit desktop, the django app is based on 1.8.2, and the docker image I use is also Ubuntu:14.04

## Install Docker

	wget -qO- https://get.docker.com/ | sh

test it:

	sudo docker run hello-world

An additional step:

	sudo usermod -aG docker your_ubuntu_username

So you don't need the annoying sudo for docker anymore.

## Question 1: should I include source code in docker?
## Question 2: how will nginx and staticfiles works with docker?
## Question 1: how to connect database if I don't want to hardcode the ip, username, password?

## enter running container

	docker exec -it CONTAINER_NAME_OR_ID bash

## run cmd in running container:

	docker exec -it CONTAINER_NAME_OR_ID python manage.py collectstatic --noinput

## Dockerfile

TODO

## Run debug site

	docker run -v /var/www/wxweb:/var/www -v /src/wxweb:/src -p 8000:8000 --name wxweb wxweb:v3

	RUN python manage.py syncdb --noinput && python manage.py migrate --noinput && python manage.py collectstatic --noinput

	docker build -t wxweb:v3 .

	docker rm `docker ps --no-trunc -aq`