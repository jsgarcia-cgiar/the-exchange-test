<?php

use Illuminate\Database\Schema\Blueprint;

use Illuminate\Database\Schema\Builder;

// HINT: you might want to use a `Flarum\Database\Migration` helper method for simplicity!
// See https://docs.flarum.org/extend/models.html#migrations to learn more about migrations.
return [
    'up' => function (Builder $schema) {
        if (!$schema->hasTable('ai_hello_clicks')) {
            $schema->create('ai_hello_clicks', function (Blueprint $table) {
                $table->increments('id');
                $table->unsignedInteger('user_id')->nullable();
                $table->timestamp('clicked_at')->useCurrent();
                $table->index('user_id');
            });
        }
    },
    'down' => function (Builder $schema) {
        $schema->dropIfExists('ai_hello_clicks');
    }
];
