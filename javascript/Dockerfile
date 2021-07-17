FROM node:14.17-alpine

WORKDIR /usr/src/app

RUN apk add build-base

{{#deps}}
  RUN apk add {{{.}}}
{{/deps}}

{{#files}}
  COPY {{source}} {{target}}
{{/files}}

{{#bootstrap}}
  RUN {{{.}}}
{{/bootstrap}}

{{#environment}}
  ENV {{{.}}}
{{/environment}}

{{#fixes}}
  RUN {{{.}}}
{{/fixes}}

CMD {{{command}}}