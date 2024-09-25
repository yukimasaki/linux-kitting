#!/bin/bash

# ====== GitHubへのSSH接続設定 ======
# SSH設定ファイルの作成
sudo -u $USERNAME bash -c "echo -e 'Host github-yukimasaki\n\tHostName github.com\n\tUser git\n\tIdentityFile ~/.ssh/id_ed25519_github\n\tStrictHostKeyChecking no' > /home/$USERNAME/.ssh/config"
sudo chmod 600 /home/$USERNAME/.ssh/config

# GitHub用SSH鍵ペアの生成
sudo -u $USERNAME ssh-keygen -t ed25519 -f /home/$USERNAME/.ssh/id_ed25519_github -N ""

# GitHub用の公開鍵表示（コピペ用）
echo "=== Copy this GitHub public key and add it to GitHub ==="
sudo cat /home/$USERNAME/.ssh/id_ed25519_github.pub

# GitHub用公開鍵ファイルの削除
sudo rm /home/$USERNAME/.ssh/id_ed25519_github.pub

# SSH接続のテスト
sudo -u $USERNAME ssh -T github-yukimasaki

# ====== Dockerのインストール ======
# インストールスクリプトを実行
sudo -u $USERNAME bash docker-install.sh