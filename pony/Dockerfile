FROM ponylang/ponyc:0.43.0

RUN apt-get -y update && apt-get -y install clang libssl-dev

WORKDIR /src/main

COPY bundle.json .
RUN stable fetch

COPY . ./

{{#environment}}
  ENV {{{.}}}
{{/environment}}

{{#before_command}}
  RUN {{{.}}}
{{/before_command}}

RUN stable env ponyc -Dopenssl_1.1.x -Dstatic

FROM ubuntu

RUN apt-get -y update && apt-get -y install openssl libatomic1

WORKDIR /opt

COPY --from=0 /src/main/main main

CMD ./main
