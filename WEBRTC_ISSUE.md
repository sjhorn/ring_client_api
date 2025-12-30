# webrtc_dart Audio RTP Routing Issue

## Status: FIXED ✅

## Summary

Audio RTP packets were not being delivered to the audio track's `onReceiveRtp` stream when using `bundlePolicy: disable`. This issue has been **resolved**.

### Resolution (2025-12-30)
- Both audio (PC1-1) and video (PC1-2) transports now connect successfully with DTLS/SRTP
- Audio RTP packets are received and forwarded to track.onReceiveRtp
- Verified audio and video packets both flowing

**Root cause**: Bug in ring_client_api/lib/src/streaming/peer_connection.dart:
```dart
// WRONG: candidate.component is 1 (RTP) or 2 (RTCP), not the m-line index
sdpMLineIndex: candidate.component,

// CORRECT: sdpMLineIndex is 0 for audio, 1 for video
sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
```

This caused ICE candidates to have incorrect m-line indices, so Ring would send DTLS packets to the wrong transport (video instead of audio).

## Current Test Results (2025-12-30)

```
[PC1-1] DTLS connected
[PC1-1] SRTP session initialized
[PC1-2] DTLS connected
[PC1-2] SRTP session initialized
Audio RTP packet #1, size=501
Audio RTP packet #2, size=495
...
Video RTP packet #1, size=67
Video RTP packet #2, size=24
...
```

- ICE connection: ✅ FIXED
- Video RTP: ✅ Working
- Audio RTP: ✅ FIXED - Both DTLS and RTP now working
- Both transports (audio PC1-1, video PC1-2) connect successfully with DTLS/SRTP

## Environment

- **webrtc_dart location**: `../webrtc_dart`
- **Ring camera streaming** with WebRTC
- **bundlePolicy**: `BundlePolicy.disable` (required by Ring - no BUNDLE group in SDP)
- **Audio codec**: Opus 48kHz stereo (confirmed via SDP)

## Observed Behavior

### TypeScript werift (WORKS)
```
2025-12-30T14:02:44.512Z ring received first audio packet
2025-12-30T14:02:45.095Z ring received first video packet
```
- Both audio AND video RTP packets are received
- Recording produces file with `video:2550KiB audio:157KiB`

### Dart webrtc_dart (BROKEN)
```
[PC] Setting up audio track: id=audio_recv_1, kind=MediaStreamTrackKind.audio
[PC] Setting up video track: id=video_recv_2, kind=MediaStreamTrackKind.video
[PC] video RTP received: #1, size=67
[PC] video RTP received: #2, size=24
...
```
- Audio track is created and `onReceiveRtp` is subscribed
- Video RTP packets ARE received (thousands of them)
- Audio RTP packets are NEVER received
- Small SRTP packets (77 bytes, 34 bytes) appear at transport level but don't reach audio track

## Code Comparison

### TypeScript werift peer-connection.ts
```typescript
const pc = new RTCPeerConnection({
  codecs: {
    audio: [
      new RTCRtpCodecParameters({ mimeType: 'audio/opus', clockRate: 48000, channels: 2 }),
      new RTCRtpCodecParameters({ mimeType: 'audio/PCMU', clockRate: 8000, channels: 1, payloadType: 0 }),
    ],
    video: [
      new RTCRtpCodecParameters({ mimeType: 'video/H264', clockRate: 90000, ... }),
    ],
  },
  iceServers: [...],
  bundlePolicy: 'disable',  // Ring requires this
});

audioTransceiver = pc.addTransceiver(this.returnAudioTrack, { direction: 'sendrecv' });
videoTransceiver = pc.addTransceiver('video', { direction: 'recvonly' });

audioTransceiver.onTrack.subscribe((track) => {
  track.onReceiveRtp.subscribe((rtp) => {
    this.onAudioRtp.next(rtp);  // THIS FIRES!
  });
});
```

### Dart webrtc_dart peer_connection.dart
```dart
_pc = webrtc.RtcPeerConnection(
  webrtc.RtcConfiguration(
    iceServers: [...],
    bundlePolicy: webrtc.BundlePolicy.disable,
    codecs: webrtc.RtcCodecs(
      audio: [
        webrtc.RtpCodecParameters(mimeType: 'audio/opus', clockRate: 48000, channels: 2),
        webrtc.RtpCodecParameters(mimeType: 'audio/PCMU', clockRate: 8000, channels: 1, payloadType: 0),
      ],
      video: [
        webrtc.RtpCodecParameters(mimeType: 'video/H264', clockRate: 90000, ...),
      ],
    ),
  ),
);

_audioTransceiver = _pc.addTransceiver(
  webrtc.MediaStreamTrackKind.audio,
  direction: webrtc.RtpTransceiverDirection.sendrecv,
);

_pc.onTrack.listen((transceiver) {
  final track = transceiver.receiver.track;
  if (transceiver.kind == webrtc.MediaStreamTrackKind.audio) {
    track.onReceiveRtp.listen((rtp) {
      onAudioRtp.add(rtp);  // THIS NEVER FIRES!
    });
  }
});
```

## Transport Architecture (bundlePolicy: disable)

With `bundlePolicy: disable`, Ring uses **separate transports** for audio and video:

```
┌─────────────────────────────────────────────────────────────┐
│                     Ring Camera                              │
└─────────────────────────────────────────────────────────────┘
                │                           │
                │ Audio (mid=1)             │ Video (mid=2)
                │ UDP port X               │ UDP port Y
                ▼                           ▼
┌───────────────────────┐     ┌───────────────────────────────┐
│ Transport 1 (PC1-1)   │     │ Transport 2 (PC1-2)           │
│ - ICE connection      │     │ - ICE connection              │
│ - DTLS handshake      │     │ - DTLS handshake              │
│ - SRTP decrypt        │     │ - SRTP decrypt                │
└───────────────────────┘     └───────────────────────────────┘
         │                              │
         │ Plain RTP                    │ Plain RTP
         ▼                              ▼
┌───────────────────────┐     ┌───────────────────────────────┐
│ Audio Transceiver     │     │ Video Transceiver             │
│ receiver.track        │     │ receiver.track                │
│ onReceiveRtp ❌       │     │ onReceiveRtp ✅               │
└───────────────────────┘     └───────────────────────────────┘
```

**Key point**: Both transports have separate ICE+DTLS. Video transport works end-to-end. Audio transport likely fails somewhere after ICE (DTLS or RTP routing).

## Suspected Root Cause

The issue is likely in one of these areas:

### 1. Transport/DTLS Setup (Most Likely)
- Each media section needs its own DTLS handshake
- Audio DTLS may not be completing or SRTP keys not derived
- **Check**: Is `[PC1-1] State: TransportState.connected` logged?
- **Check**: Are SRTP packets on audio transport being decrypted?

### 2. RTP Demultiplexing/Routing
- SRTP packets are received at transport level (we see 77-byte, 34-byte packets)
- But they're not being routed to the audio receiver
- Possibly routing by SSRC or payload type is failing
- **Check**: After SRTP decrypt, where does the RTP go?

### 3. Receiver Track Setup
- `transceiver.receiver.track` may not be the correct track
- TypeScript uses `transceiver.onTrack` callback which fires with the remote track
- Dart `transceiver.onTrack` callback exists but never fires
- **Check**: Is `receiver.receiveRtp()` being called for audio?

## Key Differences Found

1. **transceiver.onTrack callback doesn't fire**
   - TypeScript: `audioTransceiver.onTrack.subscribe((track) => ...)` fires when remote track arrives
   - Dart: `_audioTransceiver.onTrack = (track) { ... }` is set but never called

2. **PC-level onTrack fires but track may be wrong**
   - `_pc.onTrack` fires for both audio and video transceivers
   - But `transceiver.receiver.track` may not be receiving RTP

## Debug Output

Ring SDP answer shows both audio and video:
```
[SDP] audio direction: sendrecv
[SDP] video direction: sendonly
m=audio 9 UDP/TLS/RTP/SAVPF 96
m=video 9 UDP/TLS/RTP/SAVPF 96 97
```

SRTP packets at transport level (includes small audio-sized packets):
```
SRTP packet received: 77 bytes, firstByte=144
SRTP packet received: 34 bytes, firstByte=144
SRTP packet received: 1184 bytes, firstByte=144  // video
```

## Files to Investigate

In `../webrtc_dart/lib/src/`:

1. **peer_connection.dart** - `onTrack` emission, transceiver management
2. **media/rtp_transceiver.dart** - `onTrack` callback (line 44) - when should it fire?
3. **media/rtp_receiver.dart** - `receiveRtp()` method, RTP routing
4. **media/transceiver_manager.dart** - Track event firing
5. **rtp/rtp_router.dart** - RTP demultiplexing by SSRC/payload type
6. **dtls/** - DTLS handshake per transport

## Expected Fix

After fix, the following should work:
```dart
_pc.onTrack.listen((transceiver) {
  final track = transceiver.receiver.track;
  track.onReceiveRtp.listen((rtp) {
    // Should receive BOTH audio and video RTP packets
    print('${transceiver.kind} RTP: ${rtp.serialize().length} bytes');
  });
});
```

## Test Case

Run from `ring_client_api`:
```bash
dart run example/record_example.dart
```

Expected output should include:
```
[PC] audio RTP received: #1, size=...
[PC] video RTP received: #1, size=...
```

Currently only video appears.

---

# ICE Connection Failing Issue

## Status: FIXED ✅

## Summary

ICE connectivity checks timeout before reaching candidate pairs that would succeed. Server closes connection after ~14 seconds with "ICE connection failed".

**Resolution**: Fixed by improving candidate pair priority ordering.

## Observed Behavior

```
:PC1-2 Starting connectivity checks with 7 pairs
:PC1-2   - fd07:...:53891 -> 2a05:...:58602      # IPv6 - FAILS (timeout)
:PC1-2   - fd07:...:53891 -> 2a05:...:61172      # IPv6 - FAILS (timeout)
:PC1-2   - 192.168.139.3:51802 -> 51.49.110.148  # private->public - FAILS
:PC1-2   - 192.168.1.113:56715 -> 51.49.110.148  # host->public
:PC1-2   - 187.163.228.40:56715 -> 51.49.110.148 # SRFLX->public (WOULD WORK)
:PC1-2   - ...TCP pairs...

[WS] Received: close {reason: {code: 4, text: ICE connection failed}}
```

- Each failed check takes 3 seconds (STUN timeout)
- Server closes after ~14 seconds
- Only gets through 3-4 pairs before server closes
- Reflexive (SRFLX) candidate pair never gets checked

## Root Cause

1. **Candidate pair priority**: IPv6 and private IP pairs are checked before reflexive candidates
2. **Sequential checking**: Each pair waits for timeout before trying next
3. **No aggressive nomination**: Not checking multiple pairs in parallel

## Expected Behavior

Reflexive candidates (`187.163.228.40:56715 -> 51.49.110.148`) should be prioritized higher or checked in parallel so ICE succeeds before server timeout.

## Files to Investigate

- `ice/ice_connection.dart` - candidate pair priority calculation
- `ice/ice_checklist.dart` - check scheduling (sequential vs parallel)

---

## Debugging Guide

### Step 1: Verify both transports connect
Add logging to confirm both audio (PC1-1) and video (PC1-2) transports reach `TransportState.connected`:
```
[PC1-1] State: TransportState.connected  # Audio - does this appear?
[PC1-2] State: TransportState.connected  # Video - this appears
```

### Step 2: Check DTLS handshake completion
Both transports need successful DTLS handshake to derive SRTP keys:
```dart
// In dtls/dtls_transport.dart or similar
print('[DTLS-$mid] Handshake complete, SRTP keys derived');
```

### Step 3: Trace SRTP packet flow
After ICE delivers packet, trace through SRTP decrypt:
```dart
// In srtp decryption
print('[SRTP-$mid] Decrypted ${packet.length} bytes, PT=${payloadType}');
```

### Step 4: Trace RTP routing to receiver
After SRTP decrypt, trace to receiver track:
```dart
// In RTP routing / receiver
print('[RTP] Routing to ${transceiver.kind} receiver, SSRC=$ssrc');
```

### Step 5: Compare with TypeScript werift
Key files in werift to compare:
- `packages/webrtc/src/transport/dtls.ts` - DTLS handshake
- `packages/webrtc/src/media/rtpReceiver.ts` - RTP routing
- `packages/webrtc/src/peerConnection.ts` - transport management

### Quick Test
```bash
cd /Users/shorn/dev/dart/ring_client_api
source .env && RING_REFRESH_TOKEN="$refreshToken" timeout 20 dart run example/record_example.dart 2>&1 | grep -E "(Audio RTP|Video RTP|PC1-1|PC1-2|DTLS|SRTP)"
```

---

## Related

- TypeScript werift: https://github.com/AChareun/werift-webrtc
- Ring client API TypeScript: `ring/packages/ring-client-api/streaming/peer-connection.ts`
