FROM python:3.7

# Ensure that Python outputs everything that's printed inside
# the application rather than buffering it.
ENV PYTHONUNBUFFERED 1
ENV APP_ROOT /code

# Copy in your requirements file
ADD requirements.txt /requirements.txt

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step. Correct the path to your production requirements file, if needed.
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /requirements.txt

# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
ADD ./app ${APP_ROOT}
COPY mime.types /etc/mime.types
COPY uwsgi.ini /conf/uwsgi.ini

# uWSGI will listen on this port
EXPOSE 8000

# Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):
RUN if [ -f manage.py ]; then python manage.py collectstatic --noinput; fi

# Start uWSGI
CMD [ "uwsgi", "--ini", "/conf/uwsgi.ini"]
