import {defineConfig} from 'vite'
import tailwindcss from '@tailwindcss/vite';
import laravel from 'laravel-vite-plugin'
import {wordpressPlugin, wordpressThemeJson} from '@roots/vite-plugin';

export default defineConfig({
  base: '/app/themes/sage/public/build/',
  server: {
    watch: {
      usePolling: true,
    },
    host: "0.0.0.0",
    port: 5173,
    hmr: {
      // If you're running Vite on a different host than your frontend, you may need to set the client URL explicitly
      clientPort: 5173,
      // Use the public hostname of your Docker service for HMR to work properly
      host: process.env.HMR_HOST || 'localhost',
    },
  },
  plugins: [
    tailwindcss(),
    laravel({
      input: [
        'resources/css/app.css',
        'resources/js/app.js',
        'resources/css/editor.css',
        'resources/js/editor.js',
      ],
      refresh: true,
    }),

    wordpressPlugin(),

    // Generate the theme.json file in the public/build/assets directory
    // based on the Tailwind config and the theme.json file from base theme folder
    wordpressThemeJson({
      disableTailwindColors: false,
      disableTailwindFonts: false,
      disableTailwindFontSizes: false,
    }),
  ],
  resolve: {
    alias: {
      '@scripts': '/resources/js',
      '@styles': '/resources/css',
      '@fonts': '/resources/fonts',
      '@images': '/resources/images',
    },
  },
})
