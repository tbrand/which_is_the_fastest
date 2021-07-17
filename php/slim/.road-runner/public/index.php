<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Spiral\Goridge\StreamRelay;
use Spiral\RoadRunner\PSR7Client;
use Spiral\RoadRunner\Worker;

ini_set('display_errors', 'stderr');

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

$worker = new Worker(new StreamRelay(STDIN, STDOUT));
$psr7 = new PSR7Client($worker);

while ($req = $psr7->acceptRequest()) {
    try {
        $psr7->respond($app->handle($req));
    } catch (\Throwable $e) {
        $psr7->getWorker()->error((string)$e);
    }
}

