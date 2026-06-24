# 無料枠ユーザー辞書（最大 20 件）を実装する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-user-dictionary-free-tier
- Polished: 2026-06-24

## 目的

固有名詞・専門用語の誤変換を減らすため、ユーザーが「読み → 表記」の辞書を登録できるようにする。無料枠は 20 件まで（仕様書「無料プランの範囲」）。

## 優先度根拠

Medium。仕様書の無料機能として明記されているが未実装。Pro での拡張（無制限・import/export）は `0015-add-billing-foundation` 以降とする。

## 現状

- 辞書 UI・永続化・認識パイプラインへの適用がない
- `TextPostProcessor`（`Core/TextPostProcessor.swift`）は trim・句読点・フィラー除去のみ。辞書置換は未実装
- `AppConfiguration`（`Settings/Models/AppConfiguration.swift`）に辞書フィールドがない
- `ConfigStore` は `UserDefaults` ベースで設定を保存している
- 仕様書: 無料 20 件、Pro で無制限（`docs/macos-app-spec.md` 96–99 行付近）

## 設計方針

- **データモデル**: `UserDictionaryEntry` を追加する
  - フィールド: `id`（UUID）、`source`（認識結果にマッチさせる文字列）、`replacement`（置換後）、`isEnabled`（既定 true）
  - 将来の Pro 拡張（言語・適用範囲・優先度）は本 issue では持たない
- **永続化**: `Application Support/Cordierite/user-dictionary.json` に JSON 配列で保存する（`ConfigStore` と同様の Application Support 配下）
- **件数上限**: 無料 20 件。`UserDictionaryStore.add` で 21 件目を拒否し、Settings に説明を表示する。Pro ゲートは `0015` 実装後に差し替え可能な `maxEntryCount` 定数（現時点 20 固定）とする
- **適用タイミング**: 認識完了後・貼り付け前。`AppModel.stopRecording` 内で `TextPostProcessor.process` の **後** に辞書置換を適用する（フィラー除去で source が消えないよう、置換は post-processor 後が安全）
- **置換ロジック**: 純関数 `UserDictionaryReplacer.apply(_:entries:)` を `Core/` に置く。最長一致または登録順の単純置換でよい（過度な NLP は入れない）。大文字小文字は case-sensitive とする
- **UI**: `SettingsView` に **User Dictionary** セクションを追加する
  - 一覧、追加、編集、削除、有効/無効トグル
  - 残り件数表示（例: `12 / 20 entries`）
  - 21 件目追加時はアラートまたは disabled 状態
- **エンジン**: Apple Speech / Whisper 共通で post-processing 適用（エンジン API には触れない）

## 変更対象

| 種別 | パス |
|---|---|
| 新規 | `Cordierite/Cordierite/Core/UserDictionaryEntry.swift` |
| 新規 | `Cordierite/Cordierite/Core/UserDictionaryStore.swift` |
| 新規 | `Cordierite/Cordierite/Core/UserDictionaryReplacer.swift` |
| 新規 | `Cordierite/Cordierite/Settings/UserDictionarySettingsView.swift`（または SettingsView 内 Section） |
| 更新 | `Cordierite/Cordierite/Core/AppModel.swift`（stopRecording で辞書適用） |
| 更新 | `Cordierite/Cordierite/Settings/SettingsView.swift` |
| 新規 | `Cordierite/CordieriteTests/UserDictionaryReplacerTests.swift`（0008 未完了時は本 issue 内で最小 XCTest を追加してもよい） |

## 完了条件

- [ ] Settings から辞書の追加・編集・削除・有効/無効ができる
- [ ] 20 件まで登録でき、21 件目は追加できない（UI と Store の両方で enforce）
- [ ] 登録語が認識結果の貼り付けテキストに反映される（Apple Speech / Whisper 両方）
- [ ] 永続化され、アプリ再起動後も辞書が残る
- [ ] `UserDictionaryReplacer` の単体テストが存在する

## 実装方針

1. `UserDictionaryEntry` / `UserDictionaryStore` / `UserDictionaryReplacer` を追加する
2. `AppModel` の貼り付け直前パイプラインに辞書適用を挿入する
3. Settings UI を追加する
4. 置換・件数上限の XCTest を追加する
