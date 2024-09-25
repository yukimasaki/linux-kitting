# VPS起動直後
### コマンドプロンプトからSSH接続する (パスワード認証)

```bash
ssh root@example.com
```

### パッケージを更新・インストールする
```bash
apt update -y && apt install -y git
```

### 作業ディレクトリを作成する
```bash
mkdir /workspaces && cd /workspaces
```

### キッティングセット (本リポジトリ)をクローンする
```bash
git clone https://github.com/yukimasaki/linux-kitting.git
```

### スクリプトを実行する
```bash
cd linux-kitting
./1_initial-setup.sh
```
