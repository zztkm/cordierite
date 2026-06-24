# MVP テスト計画を XCTest で自動化する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/test-xctest-mvp-plan
- Polished: 2026-06-24

## 目的

仕様書「テスト計画」（`docs/macos-app-spec.md` 469–485 行）のうち、自動化可能な部分を XCTest でカバーし、リグレッションを防ぐ。

## 優先度根拠

Medium。Hold to Talk レース、無音破棄、Whisper 分岐などの修正が入ったが、テストターゲットが存在しない。`0009-add-ci-xcodebuild` の test ジョブ前提となる。

## 現状

- `Cordierite.xcodeproj` に **CordieriteTests ターゲットは存在しない**（2026-06-24 時点）
- 仕様書の手動テスト項目（権限、実マイク、実 Speech、貼り付け）は CI 自動化対象外
- テスト可能な Pure Swift モジュールは既にある:
  - `TextPostProcessor`（`Core/TextPostProcessor.swift`）
  - `SilenceDetector`（`Audio/SilenceDetector.swift`）
  - `RecordingStopResult` / `RecordingStartError`（`Core/RecordingController.swift`）
  - `RecognitionLanguageResolver`（`Speech/RecognitionLanguage.swift`）— `Speech` フレームワーク依存あり
  - `WhisperModelCatalog` / `WhisperModelOption`（`Speech/WhisperModelStore.swift`）

## 設計方針

- **CordieriteTests** ユニットテストターゲットを Xcode プロジェクトに追加する（macOS、Swift Testing ではなく XCTest）
- **第 1 段階（本 issue 必須）**: ハードウェア・権限不要の Pure Swift テスト
  - `TextPostProcessor`: trim、句読点 spacing、フィラー ON/OFF
  - `SilenceDetector`: `minimumDuration` / `minimumRMS` 境界、discard 判定
  - `UserDictionaryReplacer`: 0007 と並行の場合は 0007 側で追加。本 issue 単独ならスコープ外
- **第 2 段階（本 issue 推奨）**: `RecordingController` のロジックテスト
  - `SpeechRecognitionEngine` プロトコルの **テスト用 mock** を `CordieriteTests/` に置く
  - 無音破棄（`SilenceDetector.shouldDiscard` 経由）、二重 `start`（`RecordingStartError.alreadyRecording`）、stop 後の `RecordingStopResult` を検証
  - 実 `AVAudioEngine` / マイクは使わない
- **自動化しない（手動テストとして残す）**
  - マイク権限、Input Monitoring、Accessibility
  - 日本語/英語の実音声認識精度
  - クリップボード復元の E2E
  - Whisper モデル DL / Manage Models UI
- **対応表**: `docs/test-plan-mapping.md` に仕様書項目と XCTest / 手動の対応を 1 表で残す

## 変更対象

| 種別 | パス |
|---|---|
| 新規 | `Cordierite/CordieriteTests/` ターゲット一式 |
| 新規 | `Cordierite/CordieriteTests/TextPostProcessorTests.swift` |
| 新規 | `Cordierite/CordieriteTests/SilenceDetectorTests.swift` |
| 新規 | `Cordierite/CordieriteTests/MockSpeechRecognitionEngine.swift` |
| 新規 | `Cordierite/CordieriteTests/RecordingControllerTests.swift`（mock 使用） |
| 新規 | `docs/test-plan-mapping.md` |
| 更新 | `Cordierite/Cordierite.xcodeproj/project.pbxproj` |

## 完了条件

- [ ] `CordieriteTests` ターゲットが存在し、`xcodebuild test` でローカル実行できる
- [ ] `TextPostProcessor` と `SilenceDetector` のテストが存在する
- [ ] 無音破棄または二重 start 防止のいずれか（ ideally 両方）が `RecordingController` テストでカバーされている
- [ ] `docs/test-plan-mapping.md` に仕様書テスト計画との対応表がある
- [ ] README または `docs/test-plan-mapping.md` にテスト実行コマンドが記載されている

## テスト実行コマンド

```bash
xcodebuild \
  -project Cordierite/Cordierite.xcodeproj \
  -scheme Cordierite \
  -configuration Debug \
  -destination 'platform=macOS' \
  test
```

## 実装方針

1. Xcode で CordieriteTests ターゲットを追加し、上記 Pure Swift モジュールを `@testable import Cordierite` で参照する
2. mock engine を実装し、`RecordingController` の start/stop フローを検証する
3. 対応表 markdown を追加する
4. ローカルで `xcodebuild test` が通ることを確認する
