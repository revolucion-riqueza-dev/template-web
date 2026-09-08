import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios'

/**
 * HttpClient
 *
 * Wrapper sobre Axios que centraliza:
 * - Base URL de la API
 * - Headers de autenticación (Bearer token)
 * - Interceptores de request/response
 * - Manejo consistente de errores
 */
export class HttpClient {
  private readonly instance: AxiosInstance

  constructor(baseURL?: string) {
    this.instance = axios.create({
      baseURL: baseURL ?? process.env.NEXT_PUBLIC_API_URL ?? '/api',
      timeout: 15_000,
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      withCredentials: true, // Para cookies de Sanctum
    })

    this.setupInterceptors()
  }

  private setupInterceptors(): void {
    // ── Request: adjuntar token ──────────────────────────────
    this.instance.interceptors.request.use((config) => {
      if (typeof window !== 'undefined') {
        const token = localStorage.getItem('auth_token')
        if (token) {
          config.headers.Authorization = `Bearer ${token}`
        }
      }
      return config
    })

    // ── Response: manejo de errores globales ─────────────────
    this.instance.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          // Token expirado → redirigir a login
          if (typeof window !== 'undefined') {
            localStorage.removeItem('auth_token')
            window.location.href = '/login'
          }
        }
        return Promise.reject(error)
      }
    )
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const res: AxiosResponse<T> = await this.instance.get(url, config)
    return res.data
  }

  async post<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
    const res: AxiosResponse<T> = await this.instance.post(url, data, config)
    return res.data
  }

  async put<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
    const res: AxiosResponse<T> = await this.instance.put(url, data, config)
    return res.data
  }

  async patch<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
    const res: AxiosResponse<T> = await this.instance.patch(url, data, config)
    return res.data
  }

  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const res: AxiosResponse<T> = await this.instance.delete(url, config)
    return res.data
  }
}

// Instancia singleton para uso general
export const httpClient = new HttpClient()
