<?php

define('_APP_PATH_', __DIR__);

define('_APP_PATH_VIEW_', __DIR__ . '/View');

function uuid()
{
    return '1';
}

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../vendor/lizhichao/one/src/run.php';
require __DIR__ . '/config.php';

try {
    $req = new \One\Http\Request();
    $res = new \One\Http\Response($req);

    $router = new \One\Http\Router();
    list($req->class, $req->func, $mids, $action, $req->args, $req->as_name) = $router->explain($req->method(), $req->uri(), $req, $res);
    $f = $router->getExecAction($mids, $action, $res);
    echo $f();
} catch (\One\Exceptions\HttpException $e) {
    echo \One\Exceptions\Handler::render($e);
} catch (Throwable $e) {
    error_report($e);
    $msg = $e->getMessage();
    if ($e instanceof \One\Database\Mysql\DbException) {
        $msg = 'db error!';
    }
    echo \One\Exceptions\Handler::render(new \One\Exceptions\HttpException($res, $msg, $e->getCode()));
}
