# TurboVets Chat – Overview

- **Run**: `flutter run -d chrome` (or your target device)
- **Entry flow**: splash → loading → tab selector (Chat / Dashboard)
- **Persistence**: Hive (`chat/data/message_storage_service.dart`) storing `ChatMessage`
- **Features**:
  - Chat UI with image/text messages, emoji picker, attachment strip, manual scroll badge
  - Simulated agent replies and date headers
  - Dashboard tab loads Google via WebView

# Project Layout

- `lib/main.dart` — app bootstrap + background wrapper
- `lib/ui/screens/` — app-level screens (loading, entry selector)
- `lib/chat/`
  - `models/` — `ChatMessage`
  - `data/` — Hive storage + `ChatRepository`
  - `constants/` — seed messages, agent replies
  - `ui/pages/` — `chat.dart`
  - `ui/widgets/` — chat UI components
- `lib/dashboard/ui/` — dashboard WebView screen
- `lib/widgets/` — shared background (`app_background.dart`)

# Notes

- Audio recording is visual-only (stub).
- If you want to reset seeded messages, clear the Hive box (`MessageStorageService.clear()`).
# turbo_panel

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
