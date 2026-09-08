<?php

declare(strict_types=1);

namespace App\Infrastructure\Persistence\Repositories;

use App\Domain\Interfaces\Repositories\RepositoryInterface;
use Illuminate\Database\Eloquent\Model;

/**
 * BaseEloquentRepository
 *
 * Implementación base de repositorio usando Eloquent ORM.
 * Las capas de Dominio y Aplicación nunca importan esta clase;
 * solo la conoce el contenedor de IoC (RepositoryServiceProvider).
 *
 * @template TEntity
 * @template TModel of Model
 * @implements RepositoryInterface<TEntity>
 */
abstract class BaseEloquentRepository implements RepositoryInterface
{
    public function __construct(
        protected readonly Model $model
    ) {}

    public function findById(string $id): mixed
    {
        $record = $this->model->newQuery()->find($id);
        return $record ? $this->toDomain($record) : null;
    }

    public function findAll(int $page = 1, int $perPage = 15): array
    {
        return $this->model
            ->newQuery()
            ->paginate($perPage, ['*'], 'page', $page)
            ->getCollection()
            ->map(fn (Model $m) => $this->toDomain($m))
            ->toArray();
    }

    public function save(mixed $entity): void
    {
        $data = $this->toModel($entity);
        $this->model->newQuery()->updateOrCreate(
            ['id' => $data['id']],
            $data
        );
    }

    public function delete(string $id): void
    {
        $this->model->newQuery()->where('id', $id)->delete();
    }

    /**
     * Convierte un modelo Eloquent → entidad de dominio.
     */
    abstract protected function toDomain(Model $model): mixed;

    /**
     * Convierte una entidad de dominio → array para persistir.
     *
     * @return array<string, mixed>
     */
    abstract protected function toModel(mixed $entity): array;
}
