import { RingApi } from './ring/packages/ring-client-api/lib/api.js';
import { readFileSync } from 'fs';

// Read refresh token from .env file
const envContent = readFileSync('.env', 'utf8');
const refreshToken = envContent.split('\n')[0].split('=')[1].trim();

const ringApi = new RingApi({
  refreshToken: refreshToken,
  debug: false
});

try {
  const cameras = await ringApi.getCameras();

  console.log('=== Camera Comparison (TypeScript) ===');
  console.log(`Total cameras: ${cameras.length}\n`);

  for (const camera of cameras) {
    console.log(`Camera: ${camera.name}`);
    console.log(`  ID: ${camera.id}`);
    console.log(`  Type: ${camera.data.kind}`);
    console.log(`  Battery Level: ${camera.batteryLevel ?? "null"}`);
    console.log(`  Battery Life: ${camera.data.battery_life ?? "null"}`);
    console.log(`  Battery Life 2: ${camera.data.battery_life_2 ?? "null"}`);
    console.log(`  Battery Voltage: ${camera.data.battery_voltage ?? "null"}`);
    console.log(`  External Connection: ${camera.data.external_connection ?? "null"}`);
    console.log(`  Offline: ${camera.isOffline}`);
    console.log('');
  }

  process.exit(0);
} catch (error) {
  console.error('Error:', error.message);
  console.error(error.stack);
  process.exit(1);
}
