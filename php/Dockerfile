FROM php:8.0-fpm-alpine

RUN apk add git zlib-dev libzip-dev build-base autoconf nginx openrc curl-dev icu-dev oniguruma-dev php8-pear {{#deps}} {{{.}}} {{/deps}}
RUN docker-php-ext-install zip opcache

WORKDIR /usr/src/app

RUN ln -sfv /usr/bin/pecl8 /usr/local/bin/pecl

{{#environment}}
ENV {{{.}}}
{{/environment}}

{{#build_deps}}
  RUN apk add {{{.}}}
{{/build_deps}}

{{#php_mod}}
  RUN docker-php-ext-install {{{.}}}
{{/php_mod}}

{{#php_ext}}
  RUN mkdir -p /usr/src/php/ext/{{{extension}}} && \
    curl -fsSL https://pecl.php.net/get/{{{extension}}} | tar xvz -C "/usr/src/php/ext/{{{extension}}}" --strip 1
  RUN docker-php-ext-install {{{extension}}}
{{/php_ext}}

{{#before_build}}
  RUN {{{.}}}
{{/before_build}}

COPY . ./

ENV EVENT_EXT_FILE /usr/local/etc/php/conf.d/docker-php-ext-event.ini
RUN if [[ -f "${EVENT_EXT_FILE}" ]] ; then \
  rm -fr /usr/local/etc/php/conf.d/docker-php-ext-sockets.ini ; \
  sed -e '1i extension=sockets' /usr/local/etc/php/conf.d/docker-php-ext-event.ini > /tmp/file ; \
  mv /tmp/file /usr/local/etc/php/conf.d/docker-php-ext-event.ini ; fi

{{^standalone}}
  RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  RUN composer install --no-dev --prefer-dist --classmap-authoritative
  RUN composer dumpautoload -o
{{/standalone}}

{{#before_command}}
  RUN {{{.}}}
{{/before_command}}

{{#command}}
  CMD {{{.}}}
{{/command}}

{{^command}}
  {{#slasheddocroot}}
    RUN sed -i 's/\;prefix.*/prefix = {{{.}}}/g' /usr/local/etc/php-fpm.d/www.conf
  {{/slasheddocroot}}
  {{^slasheddocroot}}
    RUN sed -i 's/\;prefix.*/prefix = \/usr\/src\/app\/public/g' /usr/local/etc/php-fpm.d/www.conf
  {{/slasheddocroot}}
  RUN sed -i 's/\(listen =\).*/\1 \/var\/run\/php-fpm.sock/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.owner.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.group.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.mode.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  # pm.max_children set according to nproc
  RUN if [ $(nproc) = 1 ] ; then sed -i 's/\(pm\.max_children =\).*/\1 512/g' /usr/local/etc/php-fpm.d/www.conf ; else sed -i 's/\(pm\.max_children =\).*/\1 1024/g' /usr/local/etc/php-fpm.d/www.conf ; fi 
  # after 15 seconds warm-up, half of the 'idle' children are not killed
  RUN if [ $(nproc) = 1 ] ; then sed -i 's/\(pm\.max_spare_servers =\).*/\1 256/g' /usr/local/etc/php-fpm.d/www.conf ; else sed -i 's/\(pm\.max_spare_servers =\).*/\1 512/g' /usr/local/etc/php-fpm.d/www.conf ; fi 
  
  RUN rm -fr /usr/local/etc/php-fpm.d/zz-docker.conf
  
  RUN echo -e 'server {\n\
      {{#docroot}}
        root {{{.}}};\n\
      {{/docroot}}
      {{^docroot}}
        root /usr/src/app/public;\n\
      {{/docroot}}
      listen 0.0.0.0:3000;\n\
      {{#nginx_conf}}
        {{{.}}}
      {{/nginx_conf}}
      {{^nginx_conf}}
        location / {\n\
          try_files $uri $uri/ /index.php;\n\
          fastcgi_pass unix:/var/run/php-fpm.sock;\n\
          fastcgi_param   SCRIPT_FILENAME         $document_root/index.php;\n\
          include fastcgi_params;\n\
        }\n\
      {{/nginx_conf}}
  }\n'\
  > /etc/nginx/http.d/default.conf
  
  RUN echo -e 'opcache.enable=1\n\
  opcache.memory_consumption=512\n\
  opcache.interned_strings_buffer=64\n\
  opcache.max_accelerated_files=32531\n\
  opcache.validate_timestamps=0\n\
  opcache.save_comments=1\n\
  opcache.fast_shutdown=0\n'\
  >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
  
  CMD /usr/local/sbin/php-fpm --daemonize; nginx -g "daemon off;"

{{/command}}
