FROM ruby:2.4.1-alpine

RUN apk update && apk upgrade && \
    apk --no-cache add make gcc libc-dev && \
    rm -rf /var/cache/apk/*

RUN mkdir /pizzamachine
WORKDIR /pizzamachine

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install -j 20

COPY . .
