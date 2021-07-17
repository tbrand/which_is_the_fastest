<?php

use Chubbyphp\SwooleRequestHandler\OnRequest;
use Chubbyphp\SwooleRequestHandler\PsrRequestFactory;
use Chubbyphp\SwooleRequestHandler\SwooleResponseEmitter;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Psr7\Factory\ServerRequestFactory;
use Slim\Psr7\Factory\StreamFactory;
use Slim\Psr7\Factory\UploadedFileFactory;
use Swoole\Http\Server;

require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();

$app->get('/', function (Request $request, Response $response): Response {
    $response->getBody()->write("");
    return $response;
});

$app->get('/user/{id}', function (Request $request, Response $response, array $args): Response {
    $response->getBody()->write($args["id"]);
    return $response;
});

$app->post('/user', function (Request $request, Response $response): Response {
    $response->getBody()->write("");
    return $response;
});

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
