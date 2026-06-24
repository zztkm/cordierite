# README に初回セットアップ手順を記載する

- Priority: Low
- Created: 2026-06-22
- Completed: 2026-06-23
- Model: Composer 2.5
- Branch: feature/change-readme-setup-guide
- Polished: {YYYY-MM-DD}

## 目的

リポジトリを clone した開発者・利用者が、権限設定と Whisper モデル DL の流れを README だけで把握できるようにする。

## 優先度根拠

Low。アプリ内 UI と Permission Doctor で操作は可能だが、オンボーディング資料が不足している。

## 現状

- `README.md` はアプリ名と 1 行説明のみ
- ビルド要件（macOS 26、Xcode 26 等）は仕様書にのみ記載

## 設計方針

- 簡潔に: ビルド方法、必要権限、Whisper 初回 DL（Manage Models）、推奨モデルの目安
- 仕様書へのリンクを張る

## 完了条件

- README だけで clone → ビルド → 初回利用までの最低限の手順が分かる

## 解決方法

- `README.md` に要件、ビルド手順（Xcode / xcodebuild）、初回権限設定、基本操作、Whisper モデル DL 手順、推奨モデル目安、仕様書リンクを追記した
