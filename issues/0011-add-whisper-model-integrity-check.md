# Whisper モデルファイルの整合性チェックと再 DL を実装する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-whisper-model-integrity-check
- Polished: 2026-06-24

## 目的

破損・不完全 DL の ggml ファイルで Whisper が失敗したとき、ユーザーが原因を特定し Manage Models から再 DL できるようにする。

## 優先度根拠

Low。通常 DL は成功するが、中断・ディスク満杯・部分ファイル残存時にデバッグが困難。

## 現状

- `WhisperModelStore.isDownloaded`（`Speech/WhisperModelStore.swift` 249–252 行）は `FileManager.fileExists` のみ。サイズ・内容検証なし
- `WhisperModelOption.estimatedByteCount` は DL 進捗用の概算値として既に定義されている（92–103 行）
- `download` 完了時に HTTP 200 チェックはあるが、ファイルサイズの下限検証はない
- `WhisperEngine.loadRunner` / `WhisperCppRunner` ロード失敗時は `SpeechEngineError` に変換されるが、破損ファイル向けの案内は汎用メッセージ
- `WhisperModelDeletePrompt` と Manage Models UI（Settings / MenuBar）は再 DL 導線として既にある

## 設計方針

- **ダウンロード完了時**: 保存先ファイルの `fileSize` が `estimatedByteCount` の **50% 未満** なら `WhisperModelStoreError.downloadFailed`（または新規 `corruptFile`）で削除して失敗させる
- **ロード前**: `WhisperEngine.prepare` / `loadRunnerIfNeeded` で同様のサイズ下限チェック。不正なら runner を nil にし、ユーザー向けに「Delete and re-download from Manage Models」を示す
- **SHA 検証**: Hugging Face 側の SHA をリポジトリに固定値として持つのは任意（本 issue ではサイズ下限で十分。SHA は改善候補として issue に残さない）
- **エラーメッセージ**: `AppModel` の `whisperDownloadErrorMessage` / `RecordingFeedback` と整合する英語メッセージ
  - 例: `"The Whisper model file appears incomplete. Delete it in Manage Models and download again."`
- **自動削除**: 破損検出時にファイルを自動削除してよい（ユーザーが再 DL すればよい）。削除前に UI で説明する
- **Manage Models 連携**: 既存 Delete → Download フローをそのまま使う。新 UI は不要

## 変更対象

| 種別 | パス |
|---|---|
| 更新 | `Cordierite/Cordierite/Speech/WhisperModelStore.swift`（サイズ検証、`validateLocalFile`） |
| 更新 | `Cordierite/Cordierite/Speech/WhisperEngine.swift`（ロード前検証、エラー種別） |
| 更新 | `Cordierite/Cordierite/Core/AppModel.swift`（ユーザー向けメッセージ） |
| 新規 | `Cordierite/CordieriteTests/WhisperModelValidationTests.swift`（0008 完了後。未完了なら本 issue 内で最小テスト追加） |

## 完了条件

- [ ] 明らかに小さい（不完全）ファイルで DL 完了時またはロード前に分かりやすいエラーが出る
- [ ] ロード失敗時に Manage Models で Delete → Download すれば復旧できる
- [ ] 正常サイズの既存 DL ファイルに対して false positive が起きない（`estimatedByteCount` の 50% 閾値で調整可）
- [ ] サイズ検証ロジックの単体テストがある

## 実装方針

1. `WhisperModelStore` に `validateLocalFile(at:expectedMinimumBytes:)` を追加する
2. `download` 完了直後と `WhisperEngine` ロード前に呼ぶ
3. エラーメッセージを AppModel / Settings に反映する
4. 閾値境界の XCTest を追加する
