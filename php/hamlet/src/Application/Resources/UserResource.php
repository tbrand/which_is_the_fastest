<?php

namespace Application\Resources;

use Hamlet\Http\Entities\PlainTextEntity;
use Hamlet\Http\Requests\Request;
use Hamlet\Http\Resources\HttpResource;
use Hamlet\Http\Responses\{Response, SimpleOKResponse};

class UserResource implements HttpResource
{
    public function getResponse(Request $request): Response
    {
        $entity = new PlainTextEntity('');
        return new SimpleOKResponse($entity);
    }
}
