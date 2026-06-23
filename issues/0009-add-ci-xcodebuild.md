# CI で xcodebuild ビルド・テストを実行する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-ci-xcodebuild
- Polished: {YYYY-MM-DD}

## 目的

main への push / PR で macOS アプリがビルドでき、テストが走る CI を整備する。

## 優先度根拠

Medium。Whisper XCFramework や Xcode 26 依存があり、手元以外での検証が必要。

## 現状

- GitHub Actions 等の CI 設定がない（要確認）
- `objectVersion = 77` 等、Xcode バージョン依存がある

## 設計方針

- macOS runner で `xcodebuild build` / `test`
- Whisper ローカル SPM パッケージを含めた scheme を指定
- シークレット不要の範囲で実装

## 完了条件

- PR で CI が走り、ビルドが成功する
- テストターゲットがある場合は test も実行される（`0008-test-xctest-mvp-plan` 未完了時は build のみでも可 — Polished で確定）

## 解決方法

- `.github/workflows/` に workflow を追加する
- README または開発ドキュメントに必要な Xcode / macOS バージョンを記載する
