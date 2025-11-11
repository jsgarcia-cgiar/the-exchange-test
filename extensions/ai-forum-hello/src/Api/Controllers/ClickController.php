<?php

namespace Cip\AiForumHello\Api/Controllers;

use Flarum\Api\Controller\AbstractSerializeController;
use Psr\Http\Message\ServerRequestInterface;
use Tobscure\JsonApi\Collection;
use Tobscure\JsonApi\Resource;
use Tobscure\JsonApi\SerializerInterface;
use Cip\AiForumHello;
use Flarum\Http\RequestUtil;
use Illuminate\Support\Facades\DB;
use Laminas\Diactoros\Response\JsonResponse;
use Psr\Http\Message\ResponseInterface;

class ClickController
{
    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $actor = RequestUtil::getActor($request);

        DB::table('ai_hello_clicks')->insert([
            'user_id'    => $actor->isGuest() ? null : $actor->id,
            'clicked_at' => now(),
        ]);

        $name = $actor->isGuest() ? 'guest' : $actor->username;

        return new JsonResponse([
            'message' => "Hello from the backend, {$name}!",
            'time'    => now()->toIso8601String(),
        ]);
    }
}
