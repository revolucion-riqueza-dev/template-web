<?php

declare(strict_types=1);

namespace App\Application\DTOs;

/**
 * BaseDTO
 *
 * Los DTOs transportan datos entre capas sin lógica de negocio.
 * Son inmutables (readonly) y construidos desde arrays/requests.
 */
abstract class BaseDTO
{
    /**
     * Crea el DTO desde un array (ej. request validado de Laravel).
     *
     * @param  array<string, mixed> $data
     */
    abstract public static function fromArray(array $data): static;

    /**
     * Convierte el DTO a array.
     *
     * @return array<string, mixed>
     */
    abstract public function toArray(): array;
}
