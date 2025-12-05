# Turbo Panel – Angular Dashboard + Flutter Shell

## Prereqs
- Node + npm (Angular CLI compatible), Flutter SDK, Xcode/Android Studio as needed.
- Both Flutter device/emulator and the host machine must be on the same network for WebView to reach the Angular server (unless iOS simulator using `localhost`).

## Start the Angular HTTP server
- `cd dashboard`
- Install deps once: `npm install`
- Run dev server: `npm run start` (alias for `ng serve --host 0.0.0.0 --port 4200`)
- Open: `http://localhost:4200/`

## Run the Flutter app with WebView
- `cd chat`
- Install deps: `flutter pub get`
- Start the app: `flutter run 
- select the device

- Networking notes:
  - Ensure the Angular server is reachable from the device (same Wi‑Fi/LAN).
  - iOS ATS is already opened for localhost/LAN in `ios/Runner/Info.plist`.
  - For Android emulator, `10.0.2.2` maps to host; for physical Android, use your host LAN IP.


