<?php

declare(strict_types=1);

namespace App\Infrastructure\Providers;

use Illuminate\Support\ServiceProvider;

/**
 * RepositoryServiceProvider
 *
 * Registra el binding entre las interfaces de dominio y las
 * implementaciones concretas de infraestructura.
 *
 * NUNCA importes implementaciones concretas en Dominio o Aplicación;
 * el contenedor de Laravel resuelve la dependencia aquí.
 *
 * Ejemplo:
 *   $this->app->bind(
 *       \App\Domain\Interfaces\Repositories\UserRepositoryInterface::class,
 *       \App\Infrastructure\Persistence\Repositories\EloquentUserRepository::class,
 *   );
 */
class RepositoryServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        // ── Registra tus repositorios aquí ──────────────────────
        //
        // $this->app->bind(
        //     UserRepositoryInterface::class,
        //     EloquentUserRepository::class,
        // );
    }

    public function boot(): void {}
}
