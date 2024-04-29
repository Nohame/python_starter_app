#!/bin/sh

# Load specific env file
if [ -e .env ]; then
    source ".env"
else
    echo "Please set up your .env file before starting your environment."
    exit 1
fi

if [ ! -d "$APP_NAME" ]; then
  echo "Initializing the project in the folder $APP_NAME..."
  mkdir ${APP_NAME}
  cd ${APP_NAME}
else
  echo "The $APP_NAME project is already initialized."
fi

exec "$@"