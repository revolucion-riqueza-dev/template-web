<?php

declare(strict_types=1);

namespace App\Domain\Entities;

use Ramsey\Uuid\UuidInterface;
use Ramsey\Uuid\Uuid;

/**
 * BaseEntity
 *
 * Clase base para todas las entidades del dominio.
 * Las entidades tienen identidad propia (ID) y son comparadas por ella.
 */
abstract class BaseEntity
{
    protected readonly string $id;
    protected readonly \DateTimeImmutable $createdAt;
    protected \DateTimeImmutable $updatedAt;

    public function __construct(?string $id = null)
    {
        $this->id        = $id ?? Uuid::uuid4()->toString();
        $this->createdAt = new \DateTimeImmutable();
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function getId(): string
    {
        return $this->id;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getUpdatedAt(): \DateTimeImmutable
    {
        return $this->updatedAt;
    }

    protected function touch(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }

    /**
     * Las entidades se comparan por su identidad (ID), no por sus atributos.
     */
    public function equals(self $other): bool
    {
        return $this->id === $other->id;
    }
}
