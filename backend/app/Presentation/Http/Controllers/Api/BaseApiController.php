<?php

declare(strict_types=1);

namespace App\Presentation\Http\Controllers\Api;

use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller;

/**
 * BaseApiController
 *
 * Helpers de respuesta JSON consistentes para toda la API.
 */
abstract class BaseApiController extends Controller
{
    protected function success(
        mixed $data = null,
        string $message = 'OK',
        int $status = 200
    ): JsonResponse {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data'    => $data,
        ], $status);
    }

    protected function created(mixed $data = null, string $message = 'Creado correctamente'): JsonResponse
    {
        return $this->success($data, $message, 201);
    }

    protected function noContent(): JsonResponse
    {
        return response()->json(null, 204);
    }

    protected function error(
        string $message = 'Error',
        int $status = 400,
        mixed $errors = null
    ): JsonResponse {
        return response()->json([
            'success' => false,
            'message' => $message,
            'errors'  => $errors,
        ], $status);
    }

    protected function notFound(string $message = 'No encontrado'): JsonResponse
    {
        return $this->error($message, 404);
    }

    protected function serverError(string $message = 'Error interno del servidor'): JsonResponse
    {
        return $this->error($message, 500);
    }
}
