FROM ruby:2.4.1-alpine

RUN mkdir /pizzamachine
WORKDIR /pizzamachine

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install -j 20

COPY . .
