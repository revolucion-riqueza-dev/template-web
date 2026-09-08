/**
 * BaseEntity
 *
 * Clase base para todas las entidades del dominio.
 * Las entidades tienen identidad propia y se comparan por ID.
 */
export abstract class BaseEntity {
  readonly id: string
  readonly createdAt: Date
  updatedAt: Date

  constructor(id?: string) {
    this.id        = id ?? crypto.randomUUID()
    this.createdAt = new Date()
    this.updatedAt = new Date()
  }

  equals(other: BaseEntity): boolean {
    return this.id === other.id
  }

  protected touch(): void {
    this.updatedAt = new Date()
  }
}
