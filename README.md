# RecotteShader

RecotteStudioの追加エフェクトです。

## 使い方

1. RecotteStudioをインストール

1. [RecottePlugin](https://github.com/wallstudio/RecottePlugin)をインストール

1. [こちら](https://github.com/wallstudio/RecotteShader/releases/)から最新版をダウンロードして`<ユーザーフォルダ>\RecottePlugin`内に展開

1. レコスタを起動すると、エフェクトが増えています

1. ビデオオブジェクトに設定したい場合はエフェクトと併用して「シェーダー適用」トランジションを追加してください

```
Cドライブ
  └ Users
    └ <ユーザー名>
      └ RecottePlugin
        ├ README.md
        ├ install.bat
        ├ …
        └ RecotteShader
          ├ README.md
          ├ effects\
          └ …
```
## 機能


#### ブラウン管風シェーダーエフェクト

![](effects/uh_effect_ctr.png)

#### 手書き風シェーダーエフェクト

![](effects/uh_effect_edge.png)

#### ナイトビジョン風シェーダーエフェクト

![](effects/uh_effect_nv.png)

#### ゲームボーイ風シェーダーエフェクト

![](effects/uh_effect_2bc.png)

#### 境界ぼかしシェーダーエフェクト

![](effects/uh_effect_softB.png)

#### ブルームシェーダーエフェクト

![](effects/uh_effect_bloom.png)

#### パラメータ拡張エフェクト

![](effects/uh_effect_exp3D.png)

#### リムライトシェーダエフェクト（逆光）

![](effects/uh_effect_rim.png)

#### 回転エフェクト

![](effects/uh_effect_rotate.png)

## CSO（シェーダ）ビルド方法

1. [WindowsSDK](https://developer.microsoft.com/ja-jp/windows/downloads/windows-10-sdk/)をインストール

1. `build.bat`の`RECOTTE`変数に`fxc.exe`の在り処を書く

1. `build.bat`の実行

## 開発方法

環境変数`RECOTTE_SHADER_DIR`に、このリポジトリのパスを設定してください。

`uh_effect_*.lua`を参考にして新しいエフェクトファイル（`*.lua`）を作成します。
`effects`ディレクトリは通常エフェクト、`text`ディレクトリはテキスト効果エフェクト、`transitions`はトランジションエフェクトに対応しますので、任意のディレクトリ以下に配置してください。
luaライブラリを追加したい場合は`recotte_shader_effect_lib`ディレクトリ以下に配置してください。この際、requireするのは相対パスではないので注意してください。

シェーダを利用したい場合は、エフェクトファイルと同じディレクトリにHLSLファイルを作成しエフェクトファイルから呼び出します。
使える変数は、引数とメインテクスチャとサンプラーcBufferの`t`（時間）ぐらいです。cBufferの中身は`util.hlsl`に書いてありますが、LUAから渡されていない変数も多いようなのであまり当てになりません。
基本的には、LUAを経由します。記述できるのはフラグメントシェーダーのみです。

LUA（GUI）とやり取りできる変数はfloat6本＋128bitColor4本です。これではあまりに少ないので、低精度な値を複数詰め込んで、見かけ上のパラメータ数を増やしています。`util.hlsl`の`UnpackedParams`構造体を確認してください。GUIからShaderへのパラメータ受け渡しは`uh_util.lua`で定義済みなので特に触る必要はありませんが、ラベルとデフォルトだけはオーバーライドしておくと良いと思います。コピーしたLUAファイル内のコメントを好きなところを外して書き換えてください。

HLSLの編集が終わったら、`build.bat`を実行し、シェーダーをコンパイルします。RecotteStudioを再起動して、作ったエフェクトを設定します。この時、対象が映像アセットの場合、uh_dummyのトランジションも一緒に追加してください。すると、シェーダが適用されています。

## メモ

* PSの引数のposは正規化されていない（画面がFHDなら0～1920までをとる）
* PSの引数のuvpとuvは同じ値が入っている
* シェーダー適用されなくなる -> 大概は、コンパイルエラーでCSOが無い、エラーは出ない
* アイコン[icooon-mono.com](https://icooon-mono.com)
