<?php
use Mark\SimpleApp;

require __DIR__.'/../vendor/autoload.php';

$api = new SimpleApp('tcp://0.0.0.0:3000');

$api->count = 8;

$api->get('/', function ($requst) {
    return '';
});

$api->post('/user', function ($requst) {
    return '';
});

$api->get('/user/{id}', function ($requst, $id) {
    return $id;
});

$api->start();
