<?php

namespace App\Mcp\Tools;

use App\Models\User;
use PhpMcp\Server\Attributes\McpTool;
use PhpMcp\Server\Attributes\Schema;

class CreateUserTool
{
    #[McpTool(
        name: 'create-user',
        description: 'créer des utilisateurs dans la BD avec eloquent',
    )]
    public function createUser(
        #[Schema(minLength: 5, maxLength: 200)]
        string $name,

        #[Schema(minLength: 5, maxLength: 200)]
        string $email,

        #[Schema(minLength: 5, maxLength: 200)]
        string $password,

    ): array {
        return User::create([
            'name' => $name,
            'email' => $email,
            'password' => $password,
        ])->toArray();
    }
}
