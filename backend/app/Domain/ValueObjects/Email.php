<?php

declare(strict_types=1);

namespace App\Domain\ValueObjects;

use App\Domain\Exceptions\InvalidEmailException;

/**
 * Email — Value Object de ejemplo.
 */
final class Email extends BaseValueObject
{
    private readonly string $email;

    public function __construct(string $email)
    {
        $normalized = strtolower(trim($email));

        if (!filter_var($normalized, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidEmailException("Email inválido: {$email}");
        }

        $this->email = $normalized;
    }

    public function value(): string
    {
        return $this->email;
    }

    public function equals(BaseValueObject $other): bool
    {
        return $other instanceof self && $this->email === $other->email;
    }

    public function domain(): string
    {
        return substr($this->email, strpos($this->email, '@') + 1);
    }
}
