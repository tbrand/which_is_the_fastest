<?php
return [
    'host' => '0.0.0.0',
    'port' => 3000,
    'mode' => SWOOLE_BASE,
    'sockType' => SWOOLE_SOCK_TCP,
    'app' => require __DIR__ . '/swoole.php',
    'options' => [
        'worker_num'       => swoole_cpu_num() * 2,
        'enable_coroutine' => false,
        'log_file' => '/dev/null',
        'log_level' => SWOOLE_LOG_ERROR,
        'daemonize' => 0,
    ]
];
