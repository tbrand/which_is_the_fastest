FROM ruby:3.0-alpine

WORKDIR /usr/src/app

{{#files}}
  COPY {{source}} {{target}}
{{/files}}

RUN apk add build-base

RUN bundle config set without 'development test'
RUN bundle install

{{#environment}}
  ENV {{{.}}}
{{/environment}}

CMD {{{command}}}