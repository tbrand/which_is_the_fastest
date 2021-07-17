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
use Psr\Http\Message\ServerRequestInterface;
use Slim\Psr7\Factory\ResponseFactory;
use Spiral\Goridge\StreamRelay;
use Spiral\RoadRunner\Worker;
use Spiral\RoadRunner\PSR7Client;

ini_set('display_errors', 'stderr');

$loader = require __DIR__.'/../vendor/autoload.php';

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
    ]), sys_get_temp_dir() . '/chubbyphp-roadrunner.php'), $responseFactory),
]);

$worker = new Worker(new StreamRelay(STDIN, STDOUT));
$psr7 = new PSR7Client($worker);

while ($req = $psr7->acceptRequest()) {
    try {
        $psr7->respond($app->handle($req));
    } catch (\Throwable $e) {
        $psr7->getWorker()->error((string)$e);
    }
}
