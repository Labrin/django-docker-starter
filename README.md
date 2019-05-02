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

Repo includes demo `app` folder, but you can create new app just by:
```bash
$ bash starter.sh django-app <appName>
```
*Note: In case of creating new app please delete `./app` folder*

Setup development environment:
```bash
$ bash starter.sh setup

# activate virtual environment
$ source .venv/bin/activate
(.venv)$ cd /app
(.venv)$ python manage.py runserver 8080
```
*Now your Django app is available on http://localhost:8080*


## Django Quick Settings

`DEBUG` and production mode:
```python
DEBUG = False if os.environ.get("DEBUG", False) == "False" else True
PROD = not DEBUG

```

Static files:
```python

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.2/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

```

PostgreSQL Database:
```python

# Database
# https://docs.djangoproject.com/en/2.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('POSTGRES_DB', "db_name"),
        'USER': os.environ.get('POSTGRES_USER', "db_user"),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD', "veryStrongPassword"),
        'HOST': os.environ.get('POSTGRES_HOST', "localhost"),
        'PORT': os.environ.get('POSTGRES_PORT', 5432),
    }
}

```

Logging:
```python

LOG_LEVEL = 'ERROR' if PROD else 'DEBUG'
LOGGING = {
    'version': 1,
    'disable_existing_loggers': not DEBUG,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s:=> %(message)s',
        },
        'focused': {
            'format': '\n----------------------\n%(asctime)s [%(levelname)s] %(name)s:=> %(message)s \n----------------------',
        },
    },
    'handlers': {
        'my_custom_debug': {
            'level': LOG_LEVEL,
            'class': 'logging.StreamHandler',
            'formatter': 'focused',
        },
        'request_handler': {
            'level': LOG_LEVEL,
            'class': 'logging.StreamHandler',
            'formatter': 'standard',
        },
    },
    'loggers': {
        '': {
            'handlers': ['my_custom_debug'],
            'level': LOG_LEVEL,
            'propagate': True,
        },
        'django.request': {
            'handlers': ['request_handler'],
            'level': LOG_LEVEL,
            'propagate': True,
        },
    },
}

```


## Container commands

Launch production app:
```
$ docker-compose up -d --build
```

SSH into the container:
```bash
# docker exec -it <CONTAINER> bash
$ docker exec -it app bash
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
$ docker-compose run celery python manage.py migrate
```

## Oscar

To use ready to use `oscar` integration:
```bash
$ git checkout django-oscar && git fetch && git pull
$ docker-compose run web python manage.py migrate
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
