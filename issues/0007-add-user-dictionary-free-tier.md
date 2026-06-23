# 無料枠ユーザー辞書（最大 20 件）を実装する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-user-dictionary-free-tier
- Polished: {YYYY-MM-DD}

## 目的

固有名詞・専門用語の誤変換を減らすため、ユーザーが読み→表記の辞書を登録できるようにする。無料枠は 20 件まで。

## 優先度根拠

Medium。仕様書の無料機能として明記されているが未実装。

## 現状

- 辞書 UI・永続化・認識パイプラインへの適用がない
- 仕様書: 無料 20 件、Pro で拡張

## 設計方針

- UserDefaults または軽量ファイルで永続化
- 認識後 post-processing で置換、またはエンジン別の最適手段を検討
- 件数上限を無料 20 で enforce

## 完了条件

- 設定画面から辞書の追加・編集・削除ができる
- 21 件目は追加できない（無料枠）
- 登録語が貼り付けテキストに反映される

## 解決方法

- 辞書モデルと Store を追加する
- Settings に辞書管理 UI を追加する
- post-processor または認識結果処理に辞書適用を組み込む
