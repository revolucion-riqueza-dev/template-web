/**
 * UseCase<TInput, TOutput>
 *
 * Interfaz base para todos los casos de uso.
 * Un caso de uso = una acción del negocio.
 */
export interface UseCase<TInput, TOutput> {
  execute(input: TInput): Promise<TOutput>
}
