# MVP テスト計画を XCTest で自動化する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/test-xctest-mvp-plan
- Polished: {YYYY-MM-DD}

## 目的

仕様書の MVP テスト計画（状態遷移・無音破棄・権限・Whisper 分岐など）のうち、自動化可能な部分を XCTest でカバーし、リグレッションを防ぐ。

## 優先度根拠

Medium。Hold to Talk レースや権限周りの修正が入ったが、テストスイートが未整備。

## 現状

- `CordieriteTests` ターゲットの有無・内容は要確認（最小限または未作成の可能性）
- 仕様書に手動テスト項目はあるが CI 連携なし

## 設計方針

- まず Pure Swift の単体テスト（`AppState` 遷移、`RecordingController` ロジック、post-processor 等）
- マイク・Speech 実機依存は UI テストまたは手動に分離
- モック可能な境界を切る

## 完了条件

- 主要状態遷移（idle → starting → recording → transcribing 等）のテストが存在する
- 無音破棄・二重 start 防止など最近の修正に対応するテストがある
- `xcodebuild test` でローカル実行可能

## 解決方法

- テストターゲットを整備し、Core / Speech のテストを追加する
- 仕様書テスト計画と対応表をテスト README または issue コメントで残す
