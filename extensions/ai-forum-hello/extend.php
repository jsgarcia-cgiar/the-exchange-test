<?php

/*
 * This file is part of cip/ai-forum-hello.
 *
 * Copyright (c) 2025 jsgarcia.
 *
 * For the full copyright and license information, please view the LICENSE.md
 * file that was distributed with this source code.
 */

namespace Cip\AiForumHello;

use Flarum\Extend;

return [
    (new Extend\Frontend('forum'))
        ->js(__DIR__.'/js/dist/forum.js')
        ->css(__DIR__.'/less/forum.less'),
    (new Extend\Frontend('admin'))
        ->js(__DIR__.'/js/dist/admin.js')
        ->css(__DIR__.'/less/admin.less'),
    (new Extend\Settings())
        ->default('cip-ai-forum-hello.image_url', '/assets/extensions/cip-ai-forum-hello/graph-view.png')
        ->default('cip-ai-forum-hello.image_alt', 'Forum banner')
        ->serializeToForum('aiForumHello.imageUrl', 'cip-ai-forum-hello.image_url')
        ->serializeToForum('aiForumHello.imageAlt', 'cip-ai-forum-hello.image_alt'),
    new Extend\Locales(__DIR__.'/locale'),
    (new Extend\Routes('api'))
        ->post('/ai-hello/click', 'ai-hello.click', \Cip\AiForumHello\Api\Controllers\ClickController::class),
];
