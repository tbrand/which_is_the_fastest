<?php

/**
 * 路由设置
 */

use One\Http\Router;

Router::get('/', \App\Controllers\IndexController::class . '@index');

Router::get('/user/{id}', \App\Controllers\IndexController::class . '@get');

Router::post('/user', \App\Controllers\IndexController::class . '@create');
