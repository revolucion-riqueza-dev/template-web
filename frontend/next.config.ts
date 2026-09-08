import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  // Necesario para el Dockerfile de producción (multi-stage standalone)
  output: 'standalone',

  // Deshabilitar telemetría
  experimental: {
    // typedRoutes: true, // Habilitar para tipado de rutas
  },

  // Variables de entorno expuestas al cliente (NEXT_PUBLIC_*)
  // env: {},

  // Dominios permitidos para imágenes externas
  images: {
    remotePatterns: [
      // {
      //   protocol: 'https',
      //   hostname: 'example.com',
      // },
    ],
  },

  // Configuración del proxy hacia la API en desarrollo
  // (en producción Nginx se encarga del ruteo)
  async rewrites() {
    if (process.env.NODE_ENV === 'development') {
      return [
        {
          source: '/api/:path*',
          destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080/api'}/:path*`,
        },
      ]
    }
    return []
  },
}

export default nextConfig
