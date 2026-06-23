# 課金基盤（Pro サブスクリプション）を整備する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-billing-foundation
- Polished: {YYYY-MM-DD}

## 目的

仕様書の Pro 機能（辞書拡張・プロファイル・長文モード等）を提供するため、StoreKit 2 ベースの課金・権限チェック基盤を整える。

## 優先度根拠

Low。機能 MVP 完成後の収益化フェーズ。実装前に App Store Connect 設定が必要。

## 現状

- 課金コード・Entitlement 管理なし
- 仕様書: 無料 / Pro の機能分界のみ記載

## 設計方針

- StoreKit 2 + `@Observable` のサブスク状態
- Feature flag または `ProCapabilities` で Pro 機能をゲート
- サンドボックス検証手順を README に追記

## 完了条件

- サンドボックスで購入・復元・Pro 判定が動作する
- 少なくとも 1 つの Pro 機能がゲートされている（stub 可）

## 解決方法

- Billing / Subscription モジュールを追加する
- Settings に Pro 状態表示と復元ボタンを追加する
- App Store Connect で product ID を定義する（運用手順を docs に記載）
