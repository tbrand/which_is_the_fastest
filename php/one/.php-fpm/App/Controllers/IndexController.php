<?php

namespace App\Controllers;

use One\Http\Controller;

class IndexController extends Controller
{
    public function index()
    {
        return '';
    }

    public function get($id = '')
    {
        return $id;
    }

    public function create()
    {
        return '';
    }
}
