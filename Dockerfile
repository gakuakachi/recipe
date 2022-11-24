FROM ruby:3.0

ENV APP /app
RUN mkdir -p $APP

COPY . $APP/

WORKDIR $APP

RUN bundle install