<?php

declare(strict_types=1);

namespace App\Domain\ValueObjects;

/**
 * BaseValueObject
 *
 * Los Value Objects no tienen identidad propia; se comparan por sus valores.
 * Son inmutables: cualquier cambio genera un nuevo objeto.
 */
abstract class BaseValueObject
{
    /**
     * Compara este VO con otro por igualdad de valor.
     */
    abstract public function equals(self $other): bool;

    /**
     * Retorna la representación primitiva del VO.
     */
    abstract public function value(): mixed;

    public function __toString(): string
    {
        return (string) $this->value();
    }
}
