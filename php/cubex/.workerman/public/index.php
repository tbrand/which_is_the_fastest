<?php
define('PHP_START', microtime(true));

use Cubex\Workerman\CubexWorker;
use CubexMin\Application;

$loader = require_once(dirname(__DIR__) . '/vendor/autoload.php');


$worker = CubexWorker::create(
  dirname(__DIR__),
  $loader,
  function () { return new Application(); },
  'http://0.0.0.0:3000'
)->setCount(shell_exec('nproc') ? shell_exec('nproc') : 32);


$worker->start();