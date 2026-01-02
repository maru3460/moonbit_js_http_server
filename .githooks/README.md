# Git フック

## pre-commit フック

この pre-commit フックは、コミットの確定前に自動チェックを実行します。

### 使用方法

この pre-commit フックを使用するには：

1. フックが実行可能でない場合は、実行権限を付与します:
   ```bash
   chmod +x .githooks/pre-commit
   ```

2. Git に `.githooks` ディレクトリ内のフックを使用するよう設定します:
   ```bash
   git config core.hooksPath .githooks
   ```

3. `git commit` を実行するとフックが自動的に実行されます
