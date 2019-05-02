# Docker Django Boilerplate

Minimal setup for a Django project with Docker, following
[the 12factor app](https://12factor.net/) principles. This repo contains
skeleton code to get up and running with Docker & Django quickly. The
image uses [uWSGI](https://uwsgi-docs.readthedocs.io/) to host the
Django project. It's also includes [nginx-proxy](https://github.com/jwilder/nginx-proxy) to put in front in
production.  

This image is **not intended** as being a base image for a Django project.
It's a boilerplate, you can copy/paste this and use it as a base to
start a project.

## Usage

Download the repository:
```
$ git clone https://github.com/msadig/django-docker-starter.git
```

Setup development database:
```
$ cd _development && docker-compose up -d && cd ../
```


Initialize development environment:
```
$ python3 -m venv .venv
$ source .venv/bin/activate

(.venv)$ pip install -U pip
(.venv)$ pip install -r requirements.txt
(.venv)$ cd /app
(.venv)$ python manage.py runserver 8080
```
*Now your django app is available on http://localhost:8080, but it's optional for development*

## Container commands

Launch production app:
```
$ docker-compose up -d --build
```

Setup production database:
```
$ docker-compose run web python manage.py migrate
```


Collect static files:
```
$ docker-compose run web python manage.py collectstatic
```

Monitor logs *(optional)*:
```
$ docker-compose logs -f
```


### Create a Django app

```
$ docker-compose run web python manage.py startapp <appName>
```

### Create a super user
```
$ docker-compose run web python manage.py createsuperuser
```


## Celery

To use ready to use `celery` integration:
```bash
$ git checkout celery && git fetch && git pull
```

## Oscar

To use ready to use `oscar` integration:
```bash
$ git checkout django-oscar && git fetch && git pull
```


# Awesome resources

Useful awesome list to learn more about all the different components used in this repository.

* [Docker](https://github.com/veggiemonk/awesome-docker)
* [Django](https://gitlab.com/rosarior/awesome-django)
* [Python](https://github.com/vinta/awesome-python)
* [Nginx](https://github.com/agile6v/awesome-nginx)

# Useful links

* [Docker Hub Python](https://hub.docker.com/_/python/)
* [Docker Hub Postgres](https://hub.docker.com/_/postgres/)
* [Docker compose Postgres environment variables](http://stackoverflow.com/questions/29580798/docker-compose-environment-variables)
* [Quickstart: Docker Compose and Django](https://docs.docker.com/compose/django/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
