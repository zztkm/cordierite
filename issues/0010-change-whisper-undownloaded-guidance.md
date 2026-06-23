# 未 DL の Whisper モデルを Recognition で選んだときの案内を強化する

- Priority: Low
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/change-whisper-undownloaded-guidance
- Polished: {YYYY-MM-DD}

## 目的

Recognition で未ダウンロードの Whisper モデルを選んだ場合、Manage Models へ誘導する案内を分かりやすくする。DL は Manage Models のみで行う方針を維持する。

## 優先度根拠

Low。現状 `applyRecognitionSelection` で未 DL 時は Apple Speech にフォールバックしメッセージを出すが、ユーザーが次の操作を取りこぼす可能性がある。

## 現状

- 未 DL 選択時: 選択を Apple Speech に戻し、`loadingStatusMessage` に短文を表示
- Manage Models への直接リンクやモーダル案内はない

## 設計方針

- Recognition 変更時に未 DL ならアラートまたは設定画面への誘導を表示
- 自動 DL は行わない（ユーザー確認必須の方針を維持）

## 完了条件

- 未 DL モデル選択時、Manage Models で DL すべきことが UI 上明確
- 意図せず Apple Speech に切り替わったことに気づける

## 解決方法

- `AppModel.applyRecognitionSelection` と Settings / MenuBar の UI を調整する
- 必要なら `WhisperModelDownloadPrompt` を Recognition 文脈で再利用する（DL 操作自体は Manage Models に限定）
