---
name: mooncheat
description: MoonBitの構文とコアライブラリの使い方を確認するためのチートシート
allowed-tools: Read, Grep, Glob
---

- MoonBitの構文を確認するには [syntax.mbt.md](./syntax.mbt.md) を参照
- ビルトインAPIを検索
  - 構文の詳細を確認するには `~/.moon/lib/core` をGrepする
  - MoonDoc: `moon doc ArrayView`, `moon doc Array*`
- ライブラリの使用方法を確認するには `.mooncakes/` をGrepする
  - username/pkg/(src/)?pkg.generated.mbti
- 設定
  - moon.pkg.json
    - https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html を参照
    - moon.pkg.jsonのJSONスキーマ https://raw.githubusercontent.com/moonbitlang/moon/71abb232f9b661c079246a85a19ff8fe3421170a/crates/moonbuild/template/pkg.schema.json
  - moon.mod.json
    - https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html を参照
    - moon.mod.jsonのJSONスキーマ https://raw.githubusercontent.com/moonbitlang/moon/71abb232f9b661c079246a85a19ff8fe3421170a/crates/moonbuild/template/mod.schema.json
  - `moon check` の警告とアラート設定
    - 警告リストを取得: `moonc build-package -warn-help`
  - クロスターゲットビルド
    - [xplat-build.md](./xplat-build.md)
- ベンチマークの書き方 https://docs.moonbitlang.com/en/latest/language/benchmarks.html
