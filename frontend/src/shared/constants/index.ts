/** Constantes globales de la aplicación. */

export const APP_NAME = process.env.NEXT_PUBLIC_APP_NAME ?? 'My App'

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? '/api'

export const PAGINATION_DEFAULTS = {
  PAGE: 1,
  PER_PAGE: 15,
} as const

export const HTTP_STATUS = {
  OK:                    200,
  CREATED:               201,
  NO_CONTENT:            204,
  BAD_REQUEST:           400,
  UNAUTHORIZED:          401,
  FORBIDDEN:             403,
  NOT_FOUND:             404,
  UNPROCESSABLE_ENTITY:  422,
  INTERNAL_SERVER_ERROR: 500,
} as const
