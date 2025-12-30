import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    rollupOptions: {
      input: [
        'src/index.ts',
        'src/data/recoveryCodes.ts',
        'src/data/webAuthnAuthenticate.ts',
        'src/data/webAuthnRegister.ts',
        'src/data/passkeysConditionalAuth.ts',
      ],
      output: {
        assetFileNames: '[name][extname]',
        dir: 'theme/keywind/login/resources/dist',
        entryFileNames: '[name].js',
        format: 'es',
        preserveModules: false,
      },
      preserveEntrySignatures: 'exports-only',
    },
  },
});
