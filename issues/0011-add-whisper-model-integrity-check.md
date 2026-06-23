# Whisper モデルファイルの整合性チェックと再 DL を実装する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-whisper-model-integrity-check
- Polished: {YYYY-MM-DD}

## 目的

破損・不完全 DL の ggml ファイルで Whisper が失敗したとき、ユーザーが原因を特定し再 DL できるようにする。

## 優先度根拠

Low。通常 DL は成功するが、中断・ディスク満杯時にデバッグが困難。

## 現状

- `WhisperModelStore` はファイル存在のみ確認
- サイズ検証・checksum・ロード失敗時の削除案内は最小限

## 設計方針

- 既知の期待サイズまたは SHA 検証（Hugging Face 側メタがあれば利用）
- ロード失敗時に「モデルを削除して再 DL」を案内
- Manage Models から再 DL 可能

## 完了条件

- 明らかに不正なファイルで認識開始前またはロード時に分かりやすいエラーが出る
- 再 DL で復旧できる手順が UI から辿れる

## 解決方法

- `WhisperModelStore` / `WhisperEngine` に検証ロジックを追加する
- `AppModel` のエラーメッセージと Manage Models を連携する
