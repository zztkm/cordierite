# Apple Speech と Whisper の精度・性能を比較記録する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/change-benchmark-speech-engines
- Polished: {YYYY-MM-DD}

## 目的

仕様書 Milestone 5 に沿い、同じ音声セットで Apple Speech と Whisper の品質・遅延・メモリを記録し、エンジン選択の判断材料を残す。

## 優先度根拠

Medium。日本語では Whisper の方が精度が高いとの手動評価があるが、定量データと英語結果が未整理。

## 現状

- 仕様書は CER / WER / キー解放から貼り付けまでの時間 / 常駐メモリ / 失敗率を評価指標としている
- 比較用音声セットや結果の記録場所がない
- Milestone 6 は実装済みだが Milestone 5 は未実施

## 設計方針

- 短文 5〜10 本程度の固定音声（日本語・英語）で比較する
- 結果は `docs/` 配下の比較メモ（または仕様書追記）に残す
- 自動ベンチスクリプト化は本 issue の範囲外とする

## 完了条件

- 同一音声に対する Apple Speech / Whisper（既定モデル）の比較結果が文書化されている
- 遅延（録音終了から貼り付けまで）の概算が記載されている

## 解決方法

- テスト用音声と手順を定義し、計測結果を markdown にまとめる
- 必要なら仕様書 Milestone 5 を完了扱いに更新する（`0001-doc-update-macos-app-spec` と調整）
