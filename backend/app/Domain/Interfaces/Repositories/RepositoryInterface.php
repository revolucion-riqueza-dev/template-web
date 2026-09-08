<?php

declare(strict_types=1);

namespace App\Domain\Interfaces\Repositories;

/**
 * RepositoryInterface
 *
 * Contrato genérico que toda implementación de repositorio debe respetar.
 *
 * @template TEntity
 */
interface RepositoryInterface
{
    /**
     * Busca una entidad por su ID.
     *
     * @return TEntity|null
     */
    public function findById(string $id): mixed;

    /**
     * Retorna todas las entidades (con paginación opcional).
     *
     * @return array<TEntity>
     */
    public function findAll(int $page = 1, int $perPage = 15): array;

    /**
     * Persiste una entidad (insert o update).
     *
     * @param  TEntity $entity
     */
    public function save(mixed $entity): void;

    /**
     * Elimina una entidad por su ID.
     */
    public function delete(string $id): void;
}
