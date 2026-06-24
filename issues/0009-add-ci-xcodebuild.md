# CI で xcodebuild ビルド・テストを実行する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/add-ci-xcodebuild
- Polished: 2026-06-24

## 目的

main への push / PR で macOS アプリがビルドでき、テストターゲットが存在する場合は `xcodebuild test` も実行する GitHub Actions CI を整備する。

## 優先度根拠

Medium。Whisper ローカル SPM パッケージ（`Packages/WhisperCpp`）や Xcode 26 依存があり、手元以外での検証が必要。

## 現状

- `.github/workflows/` が **存在しない**（2026-06-24 時点）
- README のビルドコマンドは動作する想定（`xcodebuild -project Cordierite/Cordierite.xcodeproj -scheme Cordierite`）
- `CordieriteTests` ターゲットは未作成（`0008-test-xctest-mvp-plan` 依存）
- プロジェクトは `objectVersion = 77`、macOS 26 / Xcode 26 以上を要求（`docs/macos-app-spec.md`）
- GitHub hosted runner の macOS / Xcode バージョンが Xcode 26 未満の場合、CI が失敗するリスクがある

## 設計方針

- **トリガー**: `push` / `pull_request` を `main` ブランチ向けに設定する
- **Runner**: `macos-latest`（または利用可能な最新 macOS runner）。Xcode 26 が runner に無い場合は workflow 内で `sudo xcode-select` または `DEVELOPER_DIR` を指定し、README に「CI 要件」を明記する
- **ジョブ 1: build**（常に実行）
  ```bash
  xcodebuild \
    -project Cordierite/Cordierite.xcodeproj \
    -scheme Cordierite \
    -configuration Debug \
    -destination 'platform=macOS' \
    build
  ```
- **ジョブ 2: test**（`CordieriteTests` ターゲット追加後に有効化）
  - `0008` 未マージ時: build ジョブのみで PR を通す（test ジョブはコメントアウトまたは `if: false`）
  - `0008` マージ後: 上記 build 成功後に `xcodebuild test` を実行する
- **WhisperCpp**: ローカル SPM パッケージのため追加 checkout 不要。XCFramework はリポジトリまたは SPM 解決に含まれる構成を確認する
- **シークレット**: 不要（Hugging Face DL 等は CI 上では実行しない）
- **SwiftLint**: `prek.toml` / `.swiftlint.yml` があるが、本 issue では xcodebuild のみ。lint ジョブ追加は範囲外

## 変更対象

| 種別 | パス |
|---|---|
| 新規 | `.github/workflows/ci.yml` |
| 更新 | `README.md`（CI バッジ、必要 Xcode / macOS バージョン） |

## 完了条件

- [ ] PR で GitHub Actions が起動し、build ジョブが成功する
- [ ] `CordieriteTests` 存在時は test ジョブも成功する（0008 完了後）
- [ ] README に CI の概要とローカル再現コマンドが記載されている
- [ ] Xcode / macOS の最低要件が README または workflow コメントと矛盾しない

## 実装方針

1. `.github/workflows/ci.yml` を追加し build ジョブを定義する
2. 0008 完了後に test ステップを有効化する（同一 PR でも可）
3. README に CI セクションを追記する

## 0008 との関係

- **0008 先行**: test ジョブ込みで CI 完成
- **0009 先行**: build のみ CI。0008 マージ時に test ジョブを追加する follow-up は不要（本 issue 完了条件に test 有効化を含む）
