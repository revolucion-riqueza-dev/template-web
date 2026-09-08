/**
 * RepositoryInterface<T>
 *
 * Contrato genérico para todos los repositorios del dominio.
 * La capa de Dominio conoce SOLO esta interfaz; la implementación
 * concreta vive en Infraestructura.
 */
export interface PaginatedResult<T> {
  data: T[]
  total: number
  page: number
  perPage: number
  lastPage: number
}

export interface RepositoryInterface<T> {
  findById(id: string): Promise<T | null>
  findAll(page?: number, perPage?: number): Promise<PaginatedResult<T>>
  save(entity: T): Promise<void>
  delete(id: string): Promise<void>
}
