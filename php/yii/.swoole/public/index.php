<?php
use swoole\foundation\web\Server;
use Swoole\Runtime;

Runtime::enableCoroutine();
defined('YII_DEBUG') or define('YII_DEBUG', false);
defined('YII_ENV') or define('YII_ENV', 'prod');

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../vendor/yiisoft/yii2/Yii.php';

// require your server configuration
$config = require __DIR__ . '/../config/server.php';
// construct a server instance
$server = new Server($config);
// start the swoole server
$server->start();