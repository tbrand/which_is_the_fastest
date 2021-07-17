<?php

declare(strict_types=1);

namespace App;

use Chubbyphp\Framework\Application;
use Chubbyphp\Framework\Middleware\ExceptionMiddleware;
use Chubbyphp\Framework\Middleware\RouteMatcherMiddleware;
use Chubbyphp\Framework\RequestHandler\CallbackRequestHandler;
use Chubbyphp\Framework\Router\FastRoute\RouteMatcher;
use Chubbyphp\Framework\Router\Route;
use Chubbyphp\Framework\Router\Routes;
use Chubbyphp\SwooleRequestHandler\OnRequest;
use Chubbyphp\SwooleRequestHandler\PsrRequestFactory;
use Chubbyphp\SwooleRequestHandler\SwooleResponseEmitter;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Psr7\Factory\ResponseFactory;
use Slim\Psr7\Factory\ServerRequestFactory;
use Slim\Psr7\Factory\StreamFactory;
use Slim\Psr7\Factory\UploadedFileFactory;
use Swoole\Http\Server;

$loader = require __DIR__ . '/../vendor/autoload.php';

$responseFactory = new ResponseFactory();

$app = new Application([
    new ExceptionMiddleware($responseFactory, true),
    new RouteMatcherMiddleware(new RouteMatcher(new Routes([
        Route::get('/', 'home', new CallbackRequestHandler(
            static function () use ($responseFactory) {
                $response = $responseFactory->createResponse();
                $response->getBody()->write('');

                return $response;
            }
        )),
        Route::get('/user/{id}', 'user_view', new CallbackRequestHandler(
            static function (ServerRequestInterface $request) use ($responseFactory) {
                $response = $responseFactory->createResponse();
                $response->getBody()->write($request->getAttribute('id'));

                return $response;
            }
        )),
        Route::post('/user', 'user_list', new CallbackRequestHandler(
            static function () use ($responseFactory) {
                $response = $responseFactory->createResponse();
                $response->getBody()->write('');

                return $response;
            }
        ))
    ]), sys_get_temp_dir() . '/chubbyphp-swoole.php'), $responseFactory),
]);

$server = new Server('localhost', 3000);

$server->set([
    'worker_num' => swoole_cpu_num() * 2,
    'enable_coroutine' => false,
    'log_file' => '/dev/null',
    'log_level' => SWOOLE_LOG_ERROR,
]);

$server->on('request', new OnRequest(
    new PsrRequestFactory(
        new ServerRequestFactory(),
        new StreamFactory(),
        new UploadedFileFactory()
    ),
    new SwooleResponseEmitter(),
    $app
));

$server->start();
