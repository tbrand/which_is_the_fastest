# Which is the fastest?

[![Build Status](https://the-benchmarker.semaphoreci.com/badges/web-frameworks/branches/master.svg)](https://the-benchmarker.semaphoreci.com/projects/web-frameworks)

This project aims to be a load benchmarking suite, no more, no less

> Measuring response times (routing times) for each framework (middleware).


<div align="center">
:warning::warning::warning::warning::warning::warning::warning::warning:
</div>

<div align="center">Results are not <b>production-ready</b> <i>yet</i></div>

<div align="center">
:warning::warning::warning::warning::warning::warning::warning::warning:
</div>

### Additional purposes :

+ Helping decide between languages, depending on use case
+ Learning languages, best practices, devops culture ...
+ Having fun :heart:

## Requirements

+ [Ruby](https://ruby-lang.org) as `built-in` tools are made in this language
+ [Docker](https://www.docker.com) as **frameworks** are `isolated` into _containers_
+ [wrk](https://github.com/wg/wrk) as benchmarking tool, `>= 4.1.0`
+ [postgresql](https://www.postgresql.org) to store data, `>= 10`

:information_source::information_source::information_source::information_source::information_source:

:warning: On `OSX` you need `docker-machine` to use `docker` containerization

~~~
brew install docker-machine
docker-machine create default
eval $(docker-machine env default)
~~~

:information_source::information_source::information_source::information_source::information_source:

## Usage

... to be documented ...

feel free to create an issue if you want to try this project

## Results

:information_source:  Updated on **2020-12-10** :information_source:

> Benchmarking with [wrk](https://github.com/wg/wrk)
   + Threads : 8
   + Timeout : 8
   + Duration : 15s (seconds)

:information_source: Sorted by max `req/s` on concurrency **64** :information_source:

|    | Language | Framework | Speed (64) | Speed (256) | Speed (512) |
|----|----------|-----------|-----------:|------------:|------------:|
| 1 | java (11)| [jooby](https://jooby.io) (2.9) | 110 037.67 | 138 134.37 | 143 271.40 |
| 2 | java (11)| [rapidoid](https://rapidoid.org) (5.5) | 109 072.69 | 135 992.43 | 139 080.76 |
| 3 | java (11)| [light-4j](https://doc.networknt.com) (2.0) | 107 499.22 | 134 372.93 | 139 214.08 |
| 4 | java (11)| [act](https://actframework.org) (1.9) | 96 062.87 | 117 272.19 | 120 725.52 |
| 5 | java (11)| [restheart](https://restheart.org) (5.1) | 73 558.10 | 76 060.50 | 77 257.68 |
| 6 | java (11)| [spring-boot](https://spring.io/projects/spring-boot) (2.3) | 58 209.07 | 61 711.63 | 62 562.86 |
| 7 | java (11)| [javalin](https://javalin.io) (3.9) | 54 593.42 | 57 626.59 | 58 260.75 |
| 8 | java (11)| [spring-framework](https://spring.io/projects/spring-framework) (5.3) | 46 161.56 | 50 015.30 | 50 972.61 |
| 9 | java (11)| [micronaut](https://micronaut.io) (1.2) | 43 071.53 | 46 974.49 | 48 004.70 |
| 10 | java (11)| [blade](https://lets-blade.com) (2.0) | 13 003.87 | 15 410.98 | 14 820.42 |

## How to contribute ?

In any way you want ...

+ Request a framework addition
+ Report a bug (on any implementation)
+ Suggest an idea
+ ...

Any kind of idea is :heart:

## Contributors

- [Taichiro Suzuki](https://github.com/tbrand) - Author | Maintainer
- [OvermindDL1](https://github.com/OvermindDL1) - Maintainer
- [Marwan Rabbâa](https://github.com/waghanza) - Maintainer
