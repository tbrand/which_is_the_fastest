<?php

require_once 'vendor/autoload.php';

use laylatichy\Nano;

$nano = new Nano();

$nano->get(
    '/',
    function ($request) use ($nano) {
        $nano->response->code(200);
        $nano->response->plain('');
    }
);

$nano->get(
    '/user/{id}',
    function ($request, $id) use ($nano) {
        $nano->response->code(200);
        $nano->response->plain($id);
    }
);

$nano->post(
    '/user',
    function ($request) use ($nano) {
        $nano->response->code(200);
        $nano->response->plain('');
    }
);

$nano->start();
