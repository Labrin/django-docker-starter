#!/usr/bin/env bash

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

#Default values
CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ERROR_STATUS=0
VERSION="0.1"


# ------------------------
# Usage
function usage
{
  echo -e "Django Starter v$VERSION"
  echo -e "Sadig Muradov - sadig@muradov.org\n"
  echo -e "Usage: $0 COMMAND"
  echo -e "\nCommands:"

  echo -e "\t setup		                <- For setting up development environment"
  echo -e "\t django-app <appName>		<- Creates Django app with given name"

  echo -en "\nPlease see the README file for more info.\n\n"
  exit 1
}


# ------------------------
# Setup development env
function setup() {
  #statements
  if which python3 > /dev/null 2>&1;
  then
    #Python is installed
    python3 -m venv ${CURRENT_PATH}/.venv
    ${CURRENT_PATH}/.venv/bin/pip install -U pip
    ${CURRENT_PATH}/.venv/bin/pip install -r ${CURRENT_PATH}/requirements.txt
  else
    # Python is not installed
    echo "We require python version >3"
  fi
}

function setup_db() {
  #statements
  cd ${CURRENT_PATH}/_development && docker-compose up -d && cd ${CURRENT_PATH}
}

# ------------------------
# Create a Django app
function create_django() {
  if [ ! -d ${CURRENT_PATH}/.venv ]; then
    setup
    create_django
  else
    app_name=${2:-$(echo "app")}
    echo "Creating Django app: ${app_name}"
    ${CURRENT_PATH}/.venv/bin/pip install django
    ${CURRENT_PATH}/.venv/bin/django-admin startproject ${app_name}
  fi
}

# ------------------------
# Setup development database
function rename_django() {
  APP_NAME=${2:-$(echo "app")}
  sed -i 's|app|'${APP_NAME}'|g' ${CURRENT_PATH}/docker-compose.yml
  sed -i 's|/app|/'${APP_NAME}'|g' ${CURRENT_PATH}/Dockerfile
}


################
#### START  ####
################

COMMAND=${@:$OPTIND:1}
ARGS=${@:$OPTIND:2}

#CHECKING PARAMS VALUES
case $COMMAND in
  setup)

    setup
    setup_db

    ;;

  django-app)

    create_django $ARGS
    rename_django $ARGS

    ;;

  *)

    if [[ $COMMAND != "" ]]; then
      echo "Error: Unknown command: $COMMAND"
      ERROR_STATUS=1
    fi
    usage

    ;;
esac

exit $ERROR_STATUS
