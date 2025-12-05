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
