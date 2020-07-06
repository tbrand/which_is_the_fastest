<?php

declare(strict_types=1);
/**
 * This file is part of Simps.
 *
 * @link     https://simps.io
 * @document https://doc.simps.io
 * @license  https://github.com/simple-swoole/simps/blob/master/LICENSE
 */

return [
    'mode' => SWOOLE_BASE,
    'http' => [
        'ip' => '0.0.0.0',
        'port' => 3000,
        'sock_type' => SWOOLE_SOCK_TCP,
        'callbacks' => [
        ],
        'settings' => [
            'worker_num' => swoole_cpu_num() * 2,
            'tcp_fastopen' => true,
            'enable_reuse_port' => true,
            'enable_coroutine' => false,
            'only_simple_http' => true,
        ],
    ],
];
