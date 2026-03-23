import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.avaliacao.alunos',
  appName: 'Avaliação de Alunos',
  webDir: 'dist',
  server: {
    androidScheme: 'https',
  },
  plugins: {
    SplashScreen: {
      launchAutoHide: true,
      launchShowDuration: 2000,
      backgroundColor: '#166534',
      showSpinner: true,
      spinnerColor: '#4ade80',
      androidSpinnerStyle: 'large',
    },
    StatusBar: {
      style: 'DARK',
      backgroundColor: '#166534',
    },
  },
  android: {
    allowMixedContent: true,
    backgroundColor: '#166534',
  },
};

export default config;
