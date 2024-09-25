#!/bin/bash

# ====== 作業ディレクトリを指定 ======
cd /workspaces/linux-kitting

# ====== GitHubへのSSH接続設定 ======
# SSH設定ファイルの作成
bash -c "echo -e 'Host github-yukimasaki\n  HostName github.com\n  User git\n  Port 22\n  IdentityFile ~/.ssh/github-yukimasaki\n' > ~/.ssh/config"
chmod 600 ~/.ssh/config

# GitHub用SSH鍵ペアの生成
ssh-keygen -t ed25519 -f ~/.ssh/github-yukimasaki -N ""

# GitHub用の公開鍵表示（コピペ用）
echo -e "\n\033[1;33m=== Copy this GitHub public key and add it to GitHub ===\033[0m"
cat ~/.ssh/github-yukimasaki.pub
echo -e "\n\033[1;33m=== Copy this GitHub public key and add it to GitHub ===\033[0m"

# GitHub用公開鍵ファイルの削除
rm ~/.ssh/github-yukimasaki.pub

# SSH接続のテスト
ssh -T github-yukimasaki

# ====== Dockerのインストール ======
# インストールスクリプトを実行
./docker-install.sh