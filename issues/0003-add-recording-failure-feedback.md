# 録音・認識失敗時にユーザー向けフィードバックを出す

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-recording-failure-feedback
- Polished: {YYYY-MM-DD}

## 目的

権限不足・無音破棄・認識失敗・マイク起動失敗が `NSLog` のみだと、ユーザーは「動いていない」と感じる。次に取るべき行動を UI で示す。

## 優先度根拠

Medium。初回ホットキー問題修正後も、失敗時の可視性は製品体験に直結する。

## 現状

- `AppModel.startRecording` の catch はログのみ
- `prepareForRecording` が blocked のときホットキー経路は黙って return する
- 仕様書のエラー分類表（`docs/macos-app-spec.md`）と UI が未連動

## 設計方針

- 失敗種別ごとにメニューバーまたはトースト相当の短文メッセージを表示する
- Permission Doctor へ誘導すべきケースは `SetupIssue` に基づいて案内する
- ログ出力は残す

## 完了条件

- 録音開始失敗・無音破棄・認識失敗のいずれかで、ユーザーが原因と次の操作を UI から理解できる
- ホットキー経路でもメニューバー経路と同等のフィードバックがある

## 解決方法

- `AppModel` にユーザー向けエラーメッセージ状態を追加する
- `MenuBarView` にエラー表示を追加する
- `RecordingStopResult.discardedSilence` / `.failed` 時にもメッセージを設定する
