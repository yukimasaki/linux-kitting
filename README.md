# VPS起動直後
### コマンドプロンプトからSSH接続する (パスワード認証)

```bash
ssh root@example.com
```

### 作業ディレクトリを作成する
```bash
mkdir /workspaces && cd /workspaces
```

### キッティングセット (本リポジトリ)をクローンする
```bash
git clone https://github.com/yukimasaki/linux-kitting.git
```

### .envファイルを作成する
```bash
cd linux-kitting
cp .env.example .env
nano .env
```

### スクリプトを実行する
```bash
./1_initial-setup.sh
```