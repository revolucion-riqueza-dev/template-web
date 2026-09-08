<?php

declare(strict_types=1);

namespace App\Application\UseCases;

/**
 * BaseUseCase
 *
 * Interfaz que todos los casos de uso deben implementar.
 * Un caso de uso = una acción del negocio.
 *
 * @template TInput
 * @template TOutput
 */
interface BaseUseCase
{
    /**
     * Ejecuta el caso de uso.
     *
     * @param  TInput $input
     * @return TOutput
     */
    public function execute(mixed $input): mixed;
}
