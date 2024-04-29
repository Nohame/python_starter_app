ARG APP_NAME=python_app
ARG PYTHON_VERSION=3.12

FROM python:${PYTHON_VERSION}

LABEL maintainer="Bricozor <nohame.belkaid@gmail.com>" \
      description="Image based on Debian Stretch with Python ${PYTHON_VERSION}"

ENV APP_NAME=${APP_NAME} \
    PYTHON_VERSION=${PYTHON_VERSION}

RUN apt-get update -y && apt-get install -y \
    build-essential \
    curl \
    ssh \
    openssh-client \
    rsync \
    nano \
    screen \
    && rm -rf /var/lib/apt/lists/*  # Nettoyage du cache d'APT pour réduire la taille de l'image

RUN echo "alias ll='ls -lisa'" >> ~/.bashrc


WORKDIR /usr/src/app

COPY init-project.sh .
COPY . .

ENTRYPOINT ["./init-project.sh"]
