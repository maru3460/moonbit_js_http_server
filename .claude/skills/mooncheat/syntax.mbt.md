# MoonBit チートシート

MoonBitの構文クイックリファレンス（Rustとの違いに焦点を当てて説明）

## Rustとの主な違い

### 構文

1. 関数の戻り値型アノテーションが必須: `fn foo() -> Unit`
2. 構造体の初期化: `Point::{ x, y }` (ダブルコロン)
3. `impl` ブロックなし: `fn Type::method(...)`
4. 文字列補間: `\{...}` (波括弧)

### エラーハンドリング

5. `?` 演算子なし（明示的な `match` が必要）
6. Resultのメソッド: `map`, `unwrap_or` のみ利用可能

### ジェネリクス

7. 型パラメータは角括弧を使用: `[T]`
8. 型パラメータは関数名の前: `fn[T] name`
9. `where` 句なし: `[T : Trait]` を使用

### 名前空間

10. `use` 文なし: `@alias.function` を使用
11. 予約語のエスケープなし（代わりにサフィックス `_` を使用）

## 基本構文

```mbt

///|
// 変数
fn variables() -> Unit {
  let x = 10 // イミュータブル
  let mut y = 20 // ミュータブル
  y = y + 1
  println("\{x}, \{y}")
}

///|
// 関数式と型推論
fn function_expressions() -> Int {
  let add = fn(x, y) { x + y } // 関数式
  let add2 : (Int, Int) -> Int = (x, y) => x + y // アロー関数
  let _ = add(5, 15) + add2(10, 10)
  let _ = [1, 2, 3].map(_.mul(2)) // _.method(args) 形式
  1
}

///|
fn add_five(x : Int) -> Int {
  x + 5
}

///|
fn multiply_two(x : Int) -> Int {
  x * 2
}

///|
// パイプライン演算子
fn pipeline_example() -> Int {
  10 |> add_five |> multiply_two // 30
}

///|
struct Builder {
  mut name : String
  mut age : Int
}

///|
fn Builder::new() -> Builder {
  Builder::{ name: "", age: 0 }
}

///|
fn Builder::set_name(self : Self, n : String) -> Unit {
  self.name = n
}

///|
fn Builder::set_age(self : Self, a : Int) -> Unit {
  self.age = a
}

///|
// メソッドカスケード
fn cascade_example() -> Unit {
  let b = Builder::new()
  b..set_name("Alice")..set_age(30) // 同じレシーバでメソッドをチェーン
}
```

## パターンマッチング

```moonbit

///|
fn option_match(opt : String?) -> Int {
  match opt {
    Some(s) => s.length()
    None => 0
  }
}

///|
/// カンマを使わない
enum Status {
  Active
  Inactive
  Pending
}

///|
fn check_status(status : Status) -> String {
  match status {
    Active => "Active"
    Inactive => "Inactive"
    Pending => "Pending"
  }
}
```

## 構造体とメソッド

```moonbit

///|
/// カンマを使わない
struct Coord {
  x : Int
  y : Int
}

///|
struct Counter {
  mut value : Int
}

///|
fn Counter::new() -> Counter {
  Counter::{ value: 0 } // または { value: 0 }
}

///|
fn Counter::increment(self : Self) -> Unit {
  self.value = self.value + 1
}
```

## エラーハンドリング

```moonbit

///|
fn parse_example(s : String) -> Result[Int, String] {
  if s == "42" {
    Ok(42)
  } else {
    Err("Invalid")
  }
}

///|
// ? 演算子なし - 明示的な match が必要
fn propagate_error(s : String) -> Result[Int, String] {
  match parse_example(s) {
    Ok(n) => Ok(n * 2)
    Err(e) => Err(e)
  }
}

///|
// map は利用可能
fn with_map(s : String) -> Result[Int, String] {
  parse_example(s).map(n => n * 2)
}
```

## ジェネリクス

```moonbit

///|
// [T], fn[T] の順序で使用
pub fn[T] identity(x : T) -> T {
  x
}

///|
pub struct Container[T] {
  value : T
}

///|
// トレイト境界: [T : Trait]
pub fn[T : Show] print_value(x : T) -> Unit {
  println(x.to_string())
}
```

## 名前空間とインポート

### ビルトイン

- **ビルトイン関数**
  - `println`, `ignore`, `not`, `tap`, `panic`, `abort`, `fail`
  - アサーション: `inspect`, `assert_eq`, `assert_true`,  `assert_false`
- **ビルトイン型**:
  - `Int`, `String`, `Unit`, `Bool`,
  - `Array`, `Map`, `Set`, `Option`, `Result`, `Json`, `Iterator`, `Iter`, `Iter2`, `Failure`
  - 詳細は `cat ~/.moon/lib/core/prelude/pkg.generated.mbti` を参照
  - `T?` は `Option[T]` の省略形
- `@` 名前空間を持つコアライブラリ: `@hashmap`, `@json`, `@math`, など
  - 詳細は `ls --only-dirs ~/.moon/lib/core/` とそれぞれの `pkg.generated.mbti` を参照

### `using` ディレクティブ

`using` は他のパッケージから特定の型、値、定数、トレイトをインポートするために使用します。

```moonbit
// 型のインポート
using @immut/hashmap {
  type HashMap
}

// 複数の要素をインポート
using @pkg {
  value,           // 値
  CONST,           // 定数
  type Type,       // 型
  trait Trait,     // トレイト
}

// pub using で再エクスポート（他のパッケージで使えるようにする）
pub using @other_pkg {
  type PublicType,
}
```

**重要**: `using` は `moon.pkg.json` の `direct_use` フィールドを置き換える新しい方法です。インポートする要素の種類（`type`, `trait`, `value`）を明示的に指定する必要があります。

**使用例**:

```moonbit
using @immut/hashmap {
  type HashMap
}

fn create_map() -> Unit {
  // インポートした型を直接使用できる
  let map: HashMap[String, Int] = @immut/hashmap.new()
  ()
}
```

## ライブラリリファレンス

### 依存関係の追加

`moon.pkg.json` にライブラリを追加:

```json
{
  "import": [
    "username/package"
  ]
}
```

### APIドキュメントの検索

**コアライブラリ**: `~/.moon/lib/core/**/*.mbti` ファイルを確認
- 例: `~/.moon/lib/core/hashmap/hashmap.mbti`
- `.mbti` ファイルには型シグネチャと公開APIが含まれる

**サードパーティライブラリ**: `.mooncakes/**/*.mbti` ファイルを確認
- インストールされたパッケージはプロジェクトの `.mooncakes/` ディレクトリにキャッシュされる
- APIリファレンスとしてパッケージ構造と `.mbti` ファイルを参照

```bash
# コアライブラリのAPIを検索
ls ~/.moon/lib/core/
cat ~/.moon/lib/core/hashmap/hashmap.mbti

# サードパーティライブラリのAPIを検索
ls .mooncakes/
cat .mooncakes/username/package/lib.mbti
```

## テスト

```moonbit

///|
fn sum(a : Int, b : Int) -> Int {
  a + b
}

///|
test "sum" {
  inspect(sum(2, 3), content="5")
}
```
