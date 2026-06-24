# Whisper 選択時の言語設定を整理する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/change-whisper-language-settings
- Polished: 2026-06-24

## 目的

Apple Speech 用の言語設定（`RecognitionLanguageOption`）と Whisper 用の言語設定（`WhisperLanguageOption`）の責務を API 全体で一貫させ、ユーザーが混乱しない UI / コード構造にする。

## 優先度根拠

Low。Settings と MenuBar ではエンジン別 Language UI が **既に分岐実装済み** だが、録音開始 API が Apple Speech 前提のまま残っており、仕様書・README との用語整合も未整理。

## 現状（2026-06-24 時点）

- **UI は部分実装済み**
  - `SettingsView`: Whisper 選択時は `WhisperLanguageOption`（Auto / English / Japanese）、Apple Speech 時は `RecognitionLanguageOption`（System / English / Japanese）
  - `MenuBarView`: 同様にエンジン別 Language メニュー
- **Whisper 認識自体は動作する**: `WhisperEngine.stop()` が `whisperConfiguration.language.whisperCode` を `runner.transcribe` に渡している（`Speech/WhisperEngine.swift` 125 行）
- **不整合**
  - `AppModel.startRecording` は常に `configStore.configuration.language`（Apple Speech 用）を `RecordingController.start(language:)` に渡している（524–527 行）
  - `WhisperEngine.start(language:)` / `prepare(language:)` は `language` 引数を `_ = language` で無視している
  - `RecordingController` と `SpeechRecognitionEngine` プロトコルの `language` パラメータ名が Whisper 文脈では誤解を招く
- README は Whisper 利用時に Language で Auto Detect / English / Japanese を選ぶ手順を記載済み

## 設計方針

- **UI ラベル**: MenuBar / Settings で Whisper 選択時は **Whisper Language**、Apple Speech 時は **Language**（または **Speech Language**）と表示を分ける
- **API 整理**（いずれかを選択し、issue 実装時に確定）
  - **案 A**: `RecordingController.start` の `language` を `RecognitionLanguageOption` 専用にし、Whisper 時は engine 内部設定のみ参照（引数は `.system` 固定でも可）。プロトコル doc comment で明記
  - **案 B**: `LanguageSelection` enum（`.appleSpeech(RecognitionLanguageOption)` / `.whisper(WhisperLanguageOption)`）を導入し、Controller / Engine まで一貫して渡す
- **AppModel**: `startRecording` で現在の `recognitionEngine` に応じた言語を渡す（案 B）または Whisper 時は engine config のみ使う旨をコードで明示（案 A）
- **永続化**: 既存の `AppConfiguration.language` と `AppConfiguration.whisper.language` を維持。Whisper 選択中に `language` フィールドを変更しない
- **仕様書**: `docs/macos-app-spec.md` の Language メニュー説明（181 行付近）を実装と一致させる
- **後方互換**: 既存 UserDefaults 設定の migration は不要（フィールドは既に分離済み）

## 変更対象

| 種別 | パス |
|---|---|
| 更新 | `Cordierite/Cordierite/Core/AppModel.swift` |
| 更新 | `Cordierite/Cordierite/Core/RecordingController.swift`（必要なら） |
| 更新 | `Cordierite/Cordierite/Speech/SpeechRecognitionEngine.swift`（doc / 型） |
| 更新 | `Cordierite/Cordierite/Settings/SettingsView.swift` |
| 更新 | `Cordierite/Cordierite/UI/MenuBarView.swift` |
| 更新 | `docs/macos-app-spec.md` |

## 完了条件

- [ ] Whisper 選択時と Apple Speech 選択時で Language UI のラベルまたは説明が区別されている
- [ ] `startRecording` → `RecordingController` → 各 Engine の言語データフローがコード上で一貫している（案 A または B を README / 仕様書に 1 行記載）
- [ ] Whisper で Japanese / English / Auto を選んだ結果が `transcribe` の language 引数に反映される（現状動作の退行なし）
- [ ] Apple Speech の System / English / Japanese 選択が従来どおり動作する

## 実装方針

1. 現状 UI のラベル改善と仕様書更新
2. `AppModel.startRecording` と `RecordingController` の language 引数整理（案 A または B）
3. 手動で Apple Speech / Whisper × ja / en / auto の組み合わせを確認

## スコープ外

- 新言語の追加
- Whisper 以外のエンジン対応
