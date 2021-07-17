<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Spiral\Goridge\StreamRelay as RoadRunnerRelay;
use Spiral\RoadRunner\PSR7Client as RoadRunnerClient;
use Spiral\RoadRunner\Worker as RoadRunnerWorker;
use Sunrise\Http\Factory\ResponseFactory;
use Sunrise\Http\Factory\ServerRequestFactory;
use Sunrise\Http\Factory\StreamFactory;
use Sunrise\Http\Factory\UploadedFileFactory;
use Sunrise\Http\Router\Exception\MethodNotAllowedException;
use Sunrise\Http\Router\Exception\RouteNotFoundException;
use Sunrise\Http\Router\RequestHandler\CallableRequestHandler;
use Sunrise\Http\Router\RouteCollector;
use Sunrise\Http\Router\Router;

require_once __DIR__ . '/../vendor/autoload.php';

$routeCollector = new RouteCollector();
$responseFactory = new ResponseFactory();

$routeCollector->route('home', '/', ['GET'], new CallableRequestHandler(
    function (ServerRequestInterface $request) use ($responseFactory) : ResponseInterface {
        return $responseFactory->createResponse(200);
    }
));

$routeCollector->route('userCreate', '/user', ['POST'], new CallableRequestHandler(
    function (ServerRequestInterface $request) use ($responseFactory) : ResponseInterface {
        return $responseFactory->createResponse(201);
    }
));

$routeCollector->route('userRead', '/user/{id}', ['GET'], new CallableRequestHandler(
    function (ServerRequestInterface $request) use ($responseFactory) : ResponseInterface {
        $response = $responseFactory->createResponse(200);
        $response->getBody()->write($request->getAttribute('id'));

        return $response;
    }
));

$router = new Router();
$router->addRoute(...$routeCollector->getCollection()->all());

$client = new RoadRunnerClient(
    new RoadRunnerWorker(
        new RoadRunnerRelay(STDIN, STDOUT)
    ),
    new ServerRequestFactory(),
    new StreamFactory(),
    new UploadedFileFactory()
);

while ($request = $client->acceptRequest()) {
    try {
        $client->respond($router->handle($request));
    } catch (MethodNotAllowedException $e) {
        $client->respond($responseFactory->createResponse(405));
    } catch (RouteNotFoundException $e) {
        $client->respond($responseFactory->createResponse(404));
    } catch (Throwable $e) {
        $client->respond($responseFactory->createResponse(500));
    }
}
