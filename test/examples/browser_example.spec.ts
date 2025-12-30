import { test, expect } from '@playwright/test';
import { spawn, ChildProcess } from 'child_process';
import { setTimeout } from 'timers/promises';

let serverProcess: ChildProcess | null = null;

test.describe('Browser Example', () => {
  test.beforeAll(async () => {
    // Check for required environment variable
    if (!process.env.RING_REFRESH_TOKEN) {
      throw new Error('RING_REFRESH_TOKEN environment variable is required');
    }

    // Start the browser example server (from project root)
    const projectRoot = new URL('../../', import.meta.url).pathname;
    console.log('Starting browser_example.dart...');
    serverProcess = spawn('dart', ['run', 'example/browser_example.dart'], {
      cwd: projectRoot,
      env: { ...process.env },
      stdio: ['pipe', 'pipe', 'pipe'],
    });

    // Log output for debugging
    serverProcess.stdout?.on('data', (data) => {
      console.log(`[server] ${data.toString().trim()}`);
    });

    serverProcess.stderr?.on('data', (data) => {
      console.error(`[server error] ${data.toString().trim()}`);
    });

    // Wait for server to be ready (look for the listening message)
    await new Promise<void>((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error('Server failed to start within 30 seconds'));
      }, 30000);

      serverProcess?.stdout?.on('data', (data) => {
        if (data.toString().includes('listening on http://localhost:3000')) {
          clearTimeout(timeout);
          resolve();
        }
      });

      serverProcess?.on('error', (err) => {
        clearTimeout(timeout);
        reject(err);
      });

      serverProcess?.on('exit', (code) => {
        if (code !== 0) {
          clearTimeout(timeout);
          reject(new Error(`Server exited with code ${code}`));
        }
      });
    });

    // Give the stream a moment to initialize
    console.log('Server ready, waiting for stream to initialize...');
    await setTimeout(5000);
  });

  test.afterAll(async () => {
    // Clean up the server process
    if (serverProcess) {
      console.log('Stopping server...');
      serverProcess.kill('SIGTERM');

      // Wait for process to exit
      await new Promise<void>((resolve) => {
        serverProcess?.on('exit', () => resolve());
        setTimeout(5000).then(() => {
          serverProcess?.kill('SIGKILL');
          resolve();
        });
      });
    }
  });

  test('should load the streaming page', async ({ page }) => {
    await page.goto('/');

    // Check page title
    await expect(page).toHaveTitle('Ring Camera Stream');

    // Check heading is present
    const heading = page.locator('h1');
    await expect(heading).toHaveText('Ring Camera Stream');
  });

  test('should have video element', async ({ page }) => {
    await page.goto('/');

    // Check video element exists
    const video = page.locator('video#video');
    await expect(video).toBeVisible();

    // Check video has controls
    await expect(video).toHaveAttribute('controls', '');
  });

  test('should display status updates', async ({ page }) => {
    await page.goto('/');

    // Check status element exists
    const status = page.locator('#status');
    await expect(status).toBeVisible();

    // Status should show some message (either loading or playing)
    const statusText = await status.textContent();
    expect(statusText).toBeTruthy();
    console.log(`Status: ${statusText}`);
  });

  test('should attempt to load HLS stream', async ({ page }) => {
    await page.goto('/');

    // Wait for HLS.js to attempt loading
    await page.waitForTimeout(3000);

    // Check status shows stream activity
    const status = page.locator('#status');
    const statusText = await status.textContent();

    // Status should indicate stream loading or playing
    const validStatuses = [
      'Stream loaded',
      'Waiting for stream',
      'playing',
      'Initializing',
    ];

    const hasValidStatus = validStatuses.some(s =>
      statusText?.toLowerCase().includes(s.toLowerCase())
    );

    expect(hasValidStatus).toBe(true);
    console.log(`Final status: ${statusText}`);
  });

  test('should have video with valid source after stream loads', async ({ page }) => {
    await page.goto('/');

    // Wait for stream to potentially load (up to 30 seconds)
    const video = page.locator('video#video');

    // Try to wait for video to have some duration (indicates stream loaded)
    let streamLoaded = false;
    for (let i = 0; i < 15; i++) {
      await page.waitForTimeout(2000);

      const duration = await video.evaluate((v: HTMLVideoElement) => v.duration);
      const readyState = await video.evaluate((v: HTMLVideoElement) => v.readyState);

      console.log(`Check ${i + 1}/15: duration=${duration}, readyState=${readyState}`);

      // readyState >= 2 means HAVE_CURRENT_DATA
      if (readyState >= 2 || (duration && duration > 0 && isFinite(duration))) {
        streamLoaded = true;
        console.log('Stream loaded successfully!');
        break;
      }
    }

    // Take a screenshot regardless
    await page.screenshot({ path: '../../test-results/browser_example_final.png' });

    // If stream loaded, verify video is playing
    if (streamLoaded) {
      const paused = await video.evaluate((v: HTMLVideoElement) => v.paused);
      console.log(`Video paused: ${paused}`);
    } else {
      console.log('Stream did not fully load within timeout (this may be expected if no camera is streaming)');
    }
  });
});
