# 課金基盤（Pro サブスクリプション）を整備する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-billing-foundation
- Polished: 2026-06-24

## 目的

仕様書 Pro 機能（辞書拡張・プロファイル・長文モード等）を提供するため、StoreKit 2 ベースのサブスクリプション状態管理と Feature gate 基盤を整える。

## 優先度根拠

Low。機能 MVP 完成後の収益化フェーズ。App Store Connect で product 登録が必要。

## 現状

- 課金コード・Entitlement 管理なし
- 仕様書: 無料 / Pro 分界、USD 5/month 案（`docs/macos-app-spec.md` 68–149 行）。MVP では課金処理を実装しないと明記
- `0013` / `0014` / `0007` Pro 拡張はすべて本 issue 後にゲート可能な設計とする

## 設計方針

- **StoreKit 2**: `Product.products(for:)` / `Transaction.currentEntitlements` / `Transaction.updates` を `@MainActor` で監視
- **モジュール構成**
  - `Billing/SubscriptionManager.swift`: 購入・復元・Pro 判定
  - `Billing/ProCapabilities.swift`: feature flag enum（例: `unlimitedDictionary`, `appProfiles`, `longFormInput`）
- **状態公開**: `@Observable` な `SubscriptionManager` を `AppModel` または Environment 経由で Settings / 各機能から参照
- **Product ID**: プレースホルダ `com.zztkm.cordierite.pro.monthly`（App Store Connect 登録値は `docs/app-store-connect-setup.md` に手順のみ記載。実 ID は Connect 側で確定）
- **Settings UI**: Pro セクション — 現在のプラン表示、Subscribe、Restore Purchases
- **stub ゲート**: 少なくとも 1 機能を Pro 限定にする
  - 推奨: ユーザー辞書 21 件目（0007 実装後）または Profiles プレビュー（0013 stub）
  - 未実装機能の場合: Settings に **Pro (Preview)** トグルで `ProCapabilities` の dry-run 表示でも可
- **サンドボックス**: README / docs に Sandbox アカウント手順。機密情報（共有パスワード等）は書かない
- **オフライン**: 最後に確認した entitlement を UserDefaults に cache し、起動時に StoreKit で reconcile

## 変更対象

| 種別 | パス |
|---|---|
| 新規 | `Cordierite/Cordierite/Billing/SubscriptionManager.swift` |
| 新規 | `Cordierite/Cordierite/Billing/ProCapabilities.swift` |
| 新規 | `docs/app-store-connect-setup.md` |
| 更新 | `Cordierite/Cordierite/Settings/SettingsView.swift`（Pro セクション） |
| 更新 | `Cordierite/Cordierite/Core/AppModel.swift`（SubscriptionManager 保持） |
| 更新 | `README.md`（Sandbox テスト概要） |

## 完了条件

- [ ] Sandbox で Subscribe / Restore が動作し、Pro 状態が UI に反映される
- [ ] `ProCapabilities` 経由で少なくとも 1 機能が Pro 未加入時にブロックまたは案内される
- [ ] `docs/app-store-connect-setup.md` に product 作成・Sandbox 手順がある（秘密情報なし）
- [ ] StoreKit エラー時にユーザー向け英語メッセージが表示される

## 実装方針

1. StoreKit 2 の `SubscriptionManager` を追加する
2. Settings に Pro UI を追加する
3. 1 機能に gate を接続する（0007 辞書上限が最も自然）
4. App Store Connect 手順 doc を追加する

## スコープ外

- App Store 審査提出
- 本番 product ID の Connect 側登録作業（手順 doc のみ）
- 0013 / 0014 の本実装

## 依存関係

- **0007** 完了後: 辞書 21 件目 gate が最も意味のある stub
- 0007 未完了でも **Pro Preview** stub で完了条件を満たせる
