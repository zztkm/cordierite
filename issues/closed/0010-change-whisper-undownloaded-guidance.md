# Recognition にダウンロード済み Whisper モデルのみ表示する

- Priority: Low
- Created: 2026-06-22
- Completed: 2026-06-23
- Model: Composer 2.5
- Branch: feature/filter-recognition-whisper-models
- Polished: {YYYY-MM-DD}

## 目的

Recognition では未ダウンロードの Whisper モデルを選べないようにする。モデルの DL は Manage Models のみで行い、DL 済みのモデルだけを Recognition メニューと Settings の Picker に表示する。

## 優先度根拠

Low。未 DL モデルを選んで Apple Speech に戻される、または案内を見逃す UX をそもそも発生させない方が分かりやすい。

## 現状

- Recognition メニュー / Settings Picker に全 Whisper モデルが表示される
- 未 DL モデルには「Not downloaded」ラベルが付く
- 未 DL を選ぶと Whisper 設定は保存されるがモデルはロードされず、録音開始もブロックされる

## 設計方針

- Recognition の選択肢は Apple Speech と、DL 済み Whisper モデルのみ
- 未 DL モデルの DL は Manage Models に限定（自動 DL なし）
- 設定に未 DL の Whisper が残っている場合（削除後など）は Apple Speech にフォールバックする

## 完了条件

- Recognition UI に未 DL の Whisper モデルが表示されない
- Manage Models では従来どおり全モデルの DL / 削除ができる
- DL 済みモデルを削除したあと、Recognition が無効な Whisper 設定のまま残らない

## 解決方法

- `AppModel` に DL 済みモデル由来の Recognition 選択肢を追加する
- `MenuBarView` / `SettingsView` の Recognition UI をその選択肢に差し替える
- `applyRecognitionSelection` で未 DL 選択を拒否し、起動時・削除後に設定を整合させる
