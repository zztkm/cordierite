# 長文入力モード（Pro 想定）を設計する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-long-form-input-mode
- Polished: {YYYY-MM-DD}

## 目的

仕様書の Pro 機能「長文入力モード」（段落単位・長時間録音）の要件を整理し、Hold to Talk との共存方針を決める。

## 優先度根拠

Low。MVP のホットキー短文入力とは別 UX で、後続マイルストーン向け。

## 現状

- 録音はホットキー押下中のみ、無音タイムアウトあり
- 長時間・段落モードの UI / 状態機械なし

## 設計方針

- トグルまたは別ホットキーで長文モード
- 無音閾値・最大長・Whisper バッチ処理方針を仕様書と整合
- 課金ゲートは `0015` 実装後

## 完了条件

- 長文モードの状態遷移と UI フローが設計ドキュメント化されている
- 実装着手可能な issue 分割案がある

## 解決方法

- `docs/` に長文モード設計を追加する
- `AppState` 拡張の影響範囲を列挙する
