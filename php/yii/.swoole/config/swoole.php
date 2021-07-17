<?php

$config = require __DIR__ . '/web.php';

$config['components']['response']['class'] = swoole\foundation\web\Response::class;
$config['components']['request']['class'] = swoole\foundation\web\Request::class;
$config['components']['errorHandler']['class'] = swoole\foundation\web\ErrorHandler::class;

return $config;
