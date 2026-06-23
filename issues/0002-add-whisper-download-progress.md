# Whisper モデル DL 進捗を表示する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-whisper-download-progress
- Polished: {YYYY-MM-DD}

## 目的

Manage Models からのモデル DL 中、ユーザーが待ち時間と進行状況を把握できるようにする。

## 優先度根拠

Medium。大容量モデル（~1.5 GB）の DL では不定表示だけでは UX が悪い。

## 現状

- `WhisperEngine.downloadProgress` は `Progress(totalUnitCount: 0)` で不定表示
- `URLSession.shared.download(from:)` は bytes 進捗を返さない
- メニューバーは `assetDownloadFraction` が 0 または不定のときパーセントを出さない

## 設計方針

- `WhisperModelStore.download` を `URLSessionDownloadDelegate` または `bytes(from:delegate:)` ベースに変更し、既知サイズがあれば `Progress` に反映する
- AppModel の `loadingStatusMessage` / `assetDownloadFraction` 更新は既存フローを流用する

## 完了条件

- モデル DL 中にメニューバーまたは設定 UI で進捗（% または MB）が表示される
- DL 完了後に進捗表示が消える

## 解決方法

- `Cordierite/Cordierite/Speech/WhisperModelStore.swift` の download 実装を進捗対応に変更する
- 必要なら `AppModel.downloadWhisperModel` の progress ポーリングを調整する
