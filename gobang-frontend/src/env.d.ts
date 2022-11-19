/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_WALLET_PUBLIC_KEY: string;
  readonly VITE_WALLET_SECRET_KEY: string;
  // more env variables...
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
