<?php

use App\Kernel;

header("Access-Control-Allow-Origin:*");
header("Access-Control-Allow-Headers:X-Requested-With,Content-Type");
header("Access-Control-Allow-Methods:PUT,POST,GET,DELETE,OPTIONS");

require_once dirname(__DIR__).'/vendor/autoload_runtime.php';

return function (array $context) {
    return new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);
};
