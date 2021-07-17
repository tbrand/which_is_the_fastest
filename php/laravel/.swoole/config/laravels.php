<?php

return [
    /*
    |--------------------------------------------------------------------------
    | LaravelS Settings
    |--------------------------------------------------------------------------
    |
    | English https://github.com/hhxsv5/laravel-s/blob/master/Settings.md#laravels-settings
    | Chinese https://github.com/hhxsv5/laravel-s/blob/master/Settings-CN.md#laravels-%E9%85%8D%E7%BD%AE%E9%A1%B9
    |
    */

    /*
    |--------------------------------------------------------------------------
    | The IP address of the server
    |--------------------------------------------------------------------------
    |
    | IPv4: use "127.0.0.1" to listen local address, and "0.0.0.0" to listen all addresses.
    | IPv6: use "::1" to listen local address, and "::"(equivalent to 0:0:0:0:0:0:0:0) to listen all addresses.
    |
    */

    'listen_ip' => env('LARAVELS_LISTEN_IP', '0.0.0.0'),

    /*
    |--------------------------------------------------------------------------
    | The port of the server
    |--------------------------------------------------------------------------
    |
    | Require root privilege if port is less than 1024.
    |
    */

    'listen_port' => env('LARAVELS_LISTEN_PORT', 3000),

    /*
    |--------------------------------------------------------------------------
    | The socket type of the server
    |--------------------------------------------------------------------------
    |
    | Usually, you don’t need to care about it.
    | Unless you want Nginx to proxy to the UnixSocket Stream file, you need
    | to modify it to SWOOLE_SOCK_UNIX_STREAM, and listen_ip is the path of UnixSocket Stream file.
    | List of socket types:
    | SWOOLE_SOCK_TCP: TCP
    | SWOOLE_SOCK_TCP6: TCP IPv6
    | SWOOLE_SOCK_UDP: UDP
    | SWOOLE_SOCK_UDP6: UDP IPv6
    | SWOOLE_UNIX_DGRAM: Unix socket dgram
    | SWOOLE_UNIX_STREAM: Unix socket stream
    | Enable SSL: $sock_type | SWOOLE_SSL. To enable SSL, check the configuration about SSL.
    | https://www.swoole.co.uk/docs/modules/swoole-server-doc
    | https://www.swoole.co.uk/docs/modules/swoole-server/configuration
    |
    */

    'socket_type' => defined('SWOOLE_SOCK_TCP') ? SWOOLE_SOCK_TCP : 1,

    /*
    |--------------------------------------------------------------------------
    | Coroutine Runtime
    |--------------------------------------------------------------------------
    |
    | This value represents whether the coroutine runtime is activated or not.
    |
    | https://www.swoole.co.uk/docs/modules/swoole-runtime-flags
    |
    */

    'enable_coroutine_runtime' => false,

    /*
    |--------------------------------------------------------------------------
    | Server Name
    |--------------------------------------------------------------------------
    |
    | This value represents the name of the server that will be
    | displayed in the header of each request.
    |
    */

    'server' => env('LARAVELS_SERVER', 'LaravelS'),

    /*
    |--------------------------------------------------------------------------
    | Handle Static Resource
    |--------------------------------------------------------------------------
    |
    | Whether handle the static resource by LaravelS(Require Swoole >= 1.7.21, Handle by Swoole if Swoole >= 1.9.17).
    | Suggest that Nginx handles the statics and LaravelS handles the dynamics.
    | The default path of static resource is base_path('public'), you can modify swoole.document_root to change it.
    |
    */

    'handle_static' => env('LARAVELS_HANDLE_STATIC', false),

    /*
    |--------------------------------------------------------------------------
    | Laravel Base Path
    |--------------------------------------------------------------------------
    |
    | The basic path of Laravel, default base_path(), be used for symbolic link.
    |
    */

    'laravel_base_path' => env('LARAVEL_BASE_PATH', base_path()),

    /*
    |--------------------------------------------------------------------------
    | Inotify Reload
    |--------------------------------------------------------------------------
    |
    | This feature requires inotify extension.
    | https://github.com/hhxsv5/laravel-s#automatically-reload-after-modifying-code
    |
    */

    'inotify_reload' => [
        // Whether enable the Inotify Reload to reload all worker processes when your code is modified.
        'enable'        => env('LARAVELS_INOTIFY_RELOAD', false),

        // The file path that Inotify watches
        'watch_path'    => base_path(),

        // The file types that Inotify watches
        'file_types'    => ['.php'],

        // The excluded/ignored directories that Inotify watches
        'excluded_dirs' => [],

        // Whether output the reload log
        'log'           => true,
    ],

    /*
    |--------------------------------------------------------------------------
    | Swoole Event Handlers
    |--------------------------------------------------------------------------
    |
    | Configure the event callback function of Swoole, key-value format,
    | key is the event name, and value is the class that implements the event
    | processing interface.
    |
    | https://github.com/hhxsv5/laravel-s#configuring-the-event-callback-function-of-swoole
    |
    */

    'event_handlers' => [],

    /*
    |--------------------------------------------------------------------------
    | WebSockets
    |--------------------------------------------------------------------------
    |
    | Swoole WebSocket Server settings.
    |
    | https://github.com/hhxsv5/laravel-s#enable-websocket-server
    |
    */

    'websocket' => [
        'enable' => false,
        // 'handler' => XxxWebSocketHandler::class,
    ],

    /*
    |--------------------------------------------------------------------------
    | Sockets - multi-port mixed protocol
    |--------------------------------------------------------------------------
    |
    | The socket(port) list for TCP/UDP.
    |
    | https://github.com/hhxsv5/laravel-s#multi-port-mixed-protocol
    |
    */

    'sockets' => [],

    /*
    |--------------------------------------------------------------------------
    | Custom Process
    |--------------------------------------------------------------------------
    |
    | Support developers to create custom processes for monitoring,
    | reporting, or other special tasks.
    |
    | https://github.com/hhxsv5/laravel-s#custom-process
    |
    */

    'processes' => [],

    /*
    |--------------------------------------------------------------------------
    | Timer
    |--------------------------------------------------------------------------
    |
    | Wrapper cron job base on Swoole's Millisecond Timer, replace Linux Crontab.
    |
    | https://github.com/hhxsv5/laravel-s#millisecond-cron-job
    |
    */

    'timer' => [
        'enable'          => env('LARAVELS_TIMER', false),

        // The list of cron job
        'jobs'            => [
            // Enable LaravelScheduleJob to run `php artisan schedule:run` every 1 minute, replace Linux Crontab
            // Hhxsv5\LaravelS\Illuminate\LaravelScheduleJob::class,
        ],

        // Max waiting time of reloading
        'max_wait_time'   => 5,

        // Enable the global lock to ensure that only one instance starts the timer
        // when deploying multiple instances.
        // This feature depends on Redis https://laravel.com/docs/8.x/redis
        'global_lock'     => false,
        'global_lock_key' => config('app.name', 'Laravel'),
    ],

    /*
    |--------------------------------------------------------------------------
    | Swoole Tables
    |--------------------------------------------------------------------------
    |
    | All defined tables will be created before Swoole starting.
    |
    | https://github.com/hhxsv5/laravel-s#use-swooletable
    |
    */

    'swoole_tables' => [],

    /*
    |--------------------------------------------------------------------------
    | Re-register Providers
    |--------------------------------------------------------------------------
    |
    | The Service Provider list, will be re-registered each request, and run method boot()
    | if it exists. Usually, be used to clear the Service Provider
    | which registers Singleton instances.
    |
    | https://github.com/hhxsv5/laravel-s/blob/master/Settings.md#register_providers
    |
    */

    'register_providers' => [],

    /*
    |--------------------------------------------------------------------------
    | Cleaners
    |--------------------------------------------------------------------------
    |
    | The list of cleaners for each request is used to clean up some residual
    | global variables, singleton objects, and static properties to avoid
    | data pollution between requests.
    |
    | https://github.com/hhxsv5/laravel-s/blob/master/Settings.md#cleaners
    |
    */

    'cleaners' => [],

    /*
    |--------------------------------------------------------------------------
    | Destroy Controllers
    |--------------------------------------------------------------------------
    |
    | Automatically destroy the controllers after each request to solve
    | the problem of the singleton controllers.
    |
    | https://github.com/hhxsv5/laravel-s/blob/master/KnownIssues.md#singleton-controller
    |
    */

    'destroy_controllers' => [
        'enable'        => false,
        'excluded_list' => [],
    ],

    /*
    |--------------------------------------------------------------------------
    | Swoole Settings
    |--------------------------------------------------------------------------
    |
    | Swoole's original configuration items.
    |
    | More settings
    | Chinese https://wiki.swoole.com/#/server/setting
    | English https://www.swoole.co.uk/docs/modules/swoole-server/configuration
    |
    */

    'swoole' => [
        'worker_num'         => swoole_cpu_num() * 2,
        'pid_file'           => storage_path('laravels.pid'),
        'log_level'          => SWOOLE_LOG_ERROR,
        'log_file'           => '/dev/null',
        'enable_coroutine'   => false,
        'buffer_output_size' => 2 * 1024 * 1024, // required by laravel-s, it's default setting 2M.
    ],
];
