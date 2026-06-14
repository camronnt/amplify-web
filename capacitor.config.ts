import type { CapacitorConfig } from '@capacitor/cli';
const config: CapacitorConfig = {
  appId: 'com.cam.amplify',
  appName: 'Amplify',
  webDir: 'public',
  server: {
    allowNavigation: [
      'qrjrxgktwxklpmvkzhlh.supabase.co',
      'api.anthropic.com',
      'api.groq.com'
    ]
  }
};
export default config;
