/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: [
      'cloud.appwrite.io',
      'placehold.co',
      'images.unsplash.com'
    ],
  },
  experimental: {
    serverActions: true,
  },
  // Add rewrites to support Appwrite API routes
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: '/api/:path*',
      },
    ];
  },
};

module.exports = nextConfig;