<?php declare(strict_types=1);

use function Siler\Route\get;
use function Siler\Route\post;
use function Siler\Swoole\emit;
use function Siler\Swoole\http;

require_once __DIR__ . '/../vendor/autoload.php';

$handler = function () {
    get('/', function () {
        emit('');
    });

    get('/user/{id}', function ($params) {
        emit($params['id']);
    });

    post('/user', function () {
        emit('');
    });
};

$server = http($handler, 3000);
$server->set([
    'worker_num'       => swoole_cpu_num() * 2,
    'enable_coroutine' => false,
    'log_file' => '/dev/null',
    'log_level' => SWOOLE_LOG_ERROR,
]);
$server->start();
