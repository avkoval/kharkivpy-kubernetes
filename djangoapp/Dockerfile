FROM python:3.7-stretch
LABEL tier=dev

ENV TERM xterm-256color
ENV PYTHONUNBUFFERED 1

ARG USER_UID=1000
ARG USER_GID=1000

WORKDIR /worker/code
COPY docker/scripts/build.sh docker/scripts/

RUN /bin/bash docker/scripts/build.sh install

COPY requirements/base.txt requirements/dev.txt requirements/
RUN pip install -r requirements/base.txt && \
    pip install -r requirements/dev.txt

RUN \
    groupadd -o -f -g $USER_GID workers \
    && \
    useradd -o -d /worker -s /bin/bash -g $USER_GID -u $USER_UID worker \
    && \
    chown worker:workers -R /worker

USER worker

EXPOSE 8000
