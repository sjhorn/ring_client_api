import { RingApi } from './ring/packages/ring-client-api/lib/api.js';
import { readFileSync } from 'fs';

// Read refresh token from .env file
const envContent = readFileSync('.env', 'utf8');
const refreshToken = envContent.split('\n')[0].split('=')[1].trim();

console.log('[TEST] Testing token with TypeScript Ring API...');
console.log('[TEST] Token length:', refreshToken.length);
console.log('[TEST] Token preview:', refreshToken.substring(0, 50) + '...');

const ringApi = new RingApi({
  refreshToken: refreshToken,
  debug: true
});

try {
  console.log('[TEST] Fetching locations...');
  const locations = await ringApi.getLocations();
  console.log('[TEST] SUCCESS! Found', locations.length, 'locations');

  const cameras = await ringApi.getCameras();
  console.log('[TEST] Found', cameras.length, 'cameras');

  // Get devices from first location if it has hubs
  for (const location of locations) {
    if (location.hasHubs) {
      console.log('\n[TEST] Location:', location.name, 'has hubs, fetching devices...');
      try {
        const devices = await location.getDevices();
        console.log('[TEST] Found', devices.length, 'devices');

        // Log first full device JSON to find all numeric fields
        if (devices.length > 0) {
          console.log('\n[TEST] Full device JSON:');
          console.log(JSON.stringify(devices[0].data, null, 2));
        }
      } catch (error) {
        console.error('[TEST] Error getting devices:', error.message);
      }
      break;
    }
  }

  process.exit(0);
} catch (error) {
  console.error('[TEST] FAILED:', error.message);
  console.error(error.stack);
  process.exit(1);
}
