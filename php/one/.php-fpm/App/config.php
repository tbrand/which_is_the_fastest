<?php
//\One\Database\Mysql\Connect::setConfig(config('mysql', true));
\One\Log::setConfig(config('log', true));
\One\Http\Router::setConfig(['path' => _APP_PATH_ . '/Config/router.php']);
\One\Cache\File::setConfig(config('cache.file', true));
\One\Crypt\Openssl::setConfig(config('crypt', true));
\One\Exceptions\Handler::setConfig(config('exception', true));


// 解析路由
\One\Http\Router::loadRouter();
