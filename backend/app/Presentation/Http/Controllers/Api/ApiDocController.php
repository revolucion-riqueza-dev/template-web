<?php

namespace App\Presentation\Http\Controllers\Api;

use OpenApi\Attributes as OA;

#[OA\Info(
    version: '1.0.0',
    description: '[Descripción de la API]',
    title: '[Nombre del Proyecto] API'
)]
#[OA\Server(
    url: '/api',
    description: 'Servidor local de desarrollo'
)]
#[OA\Get(
    path: '/health',
    summary: 'Health check',
    responses: [
        new OA\Response(response: 200, description: 'OK')
    ]
)]
class ApiDocController
{
}