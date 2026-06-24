# Cordierite

Cordierite（コーディエライト）は、macOS 用のローカル音声入力アプリです。
ホットキーで録音し、オンデバイスで文字起こしして、カーソル位置に貼り付けます。

認識エンジンは **Apple Speech**（既定）と **Whisper**（whisper.cpp）に対応しています。

## 要件

- macOS 26 以上
- Apple Silicon Mac
- Xcode 26 以上（ビルド時）
- Swift 6

## ビルド

```bash
git clone https://github.com/zztkm/cordierite.git
cd cordierite
open Cordierite/Cordierite.xcodeproj
```

Xcode で **Cordierite** スキームを選び、Run（⌘R）で起動します。

コマンドラインからビルドする場合:

```bash
xcodebuild \
  -project Cordierite/Cordierite.xcodeproj \
  -scheme Cordierite \
  -configuration Debug \
  -destination 'platform=macOS' \
  build
```

ビルド成果物は DerivedData 配下に出力されます。Xcode の **Product → Show Build Folder in Finder** から `Cordierite.app` を起動できます。

## 初回セットアップ

起動後、メニューバーに Cordierite のアイコンが表示されます。初回利用前に次の権限が必要です。

| 権限 | 用途 | 設定方法 |
|---|---|---|
| Microphone | 音声入力 | 初回録音時に許可、または Permission Doctor から要求 |
| Input Monitoring | グローバルホットキー | Permission Doctor から System Settings へ誘導 |
| Accessibility | Command V による貼り付け | Permission Doctor から System Settings へ誘導 |

メニューバー → **Permission Doctor…** を開き、未設定の権限を順に許可してください。
三つすべてが **Granted** になると、状態が **Ready** になります。

## 基本的な使い方

1. 任意のアプリでテキスト入力欄にフォーカスを置く
2. 既定ホットキー **Right Option** を押しながら話す（Hold to Talk）
3. キーを離すと文字起こし結果が貼り付けられる

入力モード、ホットキー、言語、マイクはメニューバーまたは **Open Settings…** から変更できます。
既定の認識エンジンは **Apple Speech** です。初回利用時は Apple Speech アセットのダウンロードが走ることがあります。

## Whisper を使う（任意）

Whisper を使う場合は、先にモデルをダウンロードします。

1. メニューバー → **Manage Models** → 使いたいモデルの **Download…**
2. ダウンロード完了後、**Recognition: …** からその Whisper モデルを選択
3. 必要なら **Language** で Auto Detect / English / Japanese を選ぶ

| モデル | おおよそのサイズ | 目安 |
|---|---|---|
| Large v3 Turbo Q5_0 | ~500 MB | バランス重視の既定推奨 |
| Large v3 Turbo Q8_0 | ~800 MB | Q5_0 より高精度 |
| Large v3 Turbo | ~1.5 GB | 最高精度、メモリ多め |
| Base | ~140 MB | 軽量、精度は低め |

モデルファイルは `~/Library/Application Support/Cordierite/whisper-models/` に保存されます。
未ダウンロードのモデルは Recognition には表示されません。削除は **Manage Models → Delete…** から行います。

## ドキュメント

詳細な仕様・設計は [docs/macos-app-spec.md](docs/macos-app-spec.md) を参照してください。
