# macOS アプリ仕様書を実装に合わせて更新する

- Priority: Medium
- Created: 2026-06-22
- Completed: {YYYY-MM-DD}
- Model: Composer 2.5
- Branch: feature/change-update-macos-app-spec
- Polished: {YYYY-MM-DD}

## 目的

`docs/macos-app-spec.md` が whisper.cpp 実装・Recognition / Manage Models 分離・マイク権限 API など現状と乖離しており、以降の開発判断の一次資料として使えない。実装と一致させる。

## 優先度根拠

Medium。機能追加の前提となるドキュメントの正確性に直結するが、実行時の不具合は起こさない。

## 現状

- Whisper は「初期版に含めない」「mlx-whisper ヘルパー」と記載されているが、実装は whisper.cpp + Hugging Face 手動 DL
- 認識エンジン選択 UI の記載が統合前の想定のまま
- Milestone 6 が未完了扱いだが Whisper 統合は完了している
- マイク権限は `AVAudioApplication` を使用しているが仕様書に記載がない

## 設計方針

- 実装済みの内容を正とし、廃止した方針（mlx-whisper 等）は削除または「採用しなかった理由」として短く記す
- Whisper 設定項目・エラー分類・Manage Models の役割を追記する
- 収益化方針セクションとの整合を保つ

## 完了条件

- 仕様書を読むだけで、現在の Recognition / Manage Models / 権限 / Whisper の挙動が把握できる
- 実装と矛盾する記述が残っていない

## 解決方法

- `docs/macos-app-spec.md` の Whisper 節・認識エンジン抽象化・設定項目・Milestone・テスト計画を更新する
- 必要なら「採用判断」節に whisper.cpp 採用と Apple Speech 併用の理由を追記する
