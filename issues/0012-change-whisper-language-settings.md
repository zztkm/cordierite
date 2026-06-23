# Whisper 選択時の言語設定を整理する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/change-whisper-language-settings
- Polished: {YYYY-MM-DD}

## 目的

Apple Speech 用の言語設定と Whisper の言語指定（auto / ja / en 等）の関係を整理し、ユーザーが混乱しない設定 UI にする。

## 優先度根拠

Low。Whisper は多言語 auto だが、Settings の言語項目が Apple Speech 前提のままの可能性がある。

## 現状

- 仕様書: 言語は ja / en、Whisper は auto 含む
- Recognition が Whisper のとき、言語設定の意味が UI 上不明瞭になりうる

## 設計方針

- Recognition が Apple Speech のときのみ従来の言語設定を有効化
- Whisper 選択時は auto または whisper.cpp の language パラメータにマップ
- 仕様書と Settings ラベルを一致させる

## 完了条件

- Whisper 選択時に無効または別説明の設定項目が UI で区別される
- 日本語・英語の認識意図が設定から読み取れる

## 解決方法

- Settings / `AppModel` の言語適用ロジックを見直す
- `WhisperEngine` の transcribe 呼び出しに言語を渡す
