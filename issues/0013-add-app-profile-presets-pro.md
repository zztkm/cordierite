# アプリ別プロファイル・文体プリセット（Pro 想定）を設計する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-app-profile-presets-pro
- Polished: {YYYY-MM-DD}

## 目的

仕様書の Pro 機能「アプリ別プロファイル・文体プリセット」の要件を整理し、MVP 後の実装に向けたデータモデルと UI 方針を定める。

## 優先度根拠

Low。収益化・差別化機能であり、現 MVP には必須ではない。

## 現状

- 単一の認識設定のみ
- 仕様書: Slack / メール / コード等のプリセットを Pro で提供

## 設計方針

- 本 issue は設計 + 最小スケルトンまで。課金連動は `0015-add-billing-foundation` に依存
- プロファイル = 認識エンジン + post-processing + 辞書スコープ等のバンドル

## 完了条件

- プロファイルのデータモデルと Settings UI ワイヤ（または stub）が存在する
- 仕様書 Pro 節との対応が文書化されている

## 解決方法

- 設計メモを `docs/` に追加する
- 必要なら `Profile` 型と Settings の placeholder を実装する
