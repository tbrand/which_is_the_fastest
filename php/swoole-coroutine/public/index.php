<?php

use Swoole\Process\Pool;
use Swoole\Coroutine\Http\Server;

$worker_num = swoole_cpu_num() * 2;

/**
 * The Coroutine\Http\Server does not automatically create multiple processes,
 * needs to be used with the Process\Pool module to take advantage of multiple cores.
 */
$pool = new Pool($worker_num);
$pool->set(['enable_coroutine' => true]);
$pool->on('workerStart', function ($pool, $id) {
    $server = new Server('0.0.0.0', 3000, false, true);
    $server->handle('/', function ($request, $response) {
        $response->end('');
    });
    $server->handle('/user', function ($request, $response) {
        $response->end(substr($request->server['request_uri'], 6));
    });
    $server->start();
});
$pool->start();
