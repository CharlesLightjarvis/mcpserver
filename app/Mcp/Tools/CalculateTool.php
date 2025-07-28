<?php

namespace App\Mcp\Tools;

use PhpMcp\Server\Attributes\{McpTool};
use PhpMcp\Server\Attributes\Schema;

class CalculateTool
{
    #[McpTool(
        name: 'addition',
        description: 'additionner deux nombres',
    )]
    public function calculate(
        #[Schema(minimum: 1, maximum: 120)]
        int $a,

        #[Schema(minimum: 1, maximum: 120)]
        int $b
    ): int {
        return $a + $b;
    }
}
