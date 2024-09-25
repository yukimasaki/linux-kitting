#!/bin/bash

# ====== ユーザー作成とsudo権限の付与 ======
# .envファイルを読み込む
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found. Please create it with USERNAME and PASSWORD variables."
  exit 1
fi

# USERNAMEとPASSWORDは.envファイルから読み込まれる
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "USERNAME or PASSWORD is not set in the .env file."
  exit 1
fi

# ユーザー作成
useradd -m -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

# ユーザーにsudo権限を付与
usermod -aG sudo $USERNAME

# ====== パッケージの更新・インストール ======
apt update -y
apt install -y git

# ====== SSH公開鍵認証の設定 ======
# SSHディレクトリの作成と権限の設定
mkdir -p /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh

# SSH鍵ペアの生成 (ユーザーの権限で実行)
ssh-keygen -t ed25519 -f /home/$USERNAME/.ssh/id_ed25519 -N ""

# 公開鍵をauthorized_keysに追記
cat /home/$USERNAME/.ssh/id_ed25519.pub >> /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# キーペアを削除
rm /home/$USERNAME/.ssh/id_ed25519
rm /home/$USERNAME/.ssh/id_ed25519.pub

# SSHサーバー設定の変更 (公開鍵認証を有効化)
sed -i 's/^#\?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

systemctl reload sshd

# 秘密鍵の表示（コピペ用）
echo "=== Copy this private key and store it securely ==="
cat /home/$USERNAME/.ssh/id_ed25519

# コンソールの表示言語を英語に変更
# 追加する行
NEW_ENTRY="export LANG=en_US"

# ~/.bashrcに既に同じ設定があるか確認
if grep -Fxq "$NEW_ENTRY" ~/.bashrc; then
  echo "LANG is already set in ~/.bashrc."
else
  # ~/.bashrcに設定を追加
  echo "$NEW_ENTRY" >> ~/.bashrc
  echo "LANG has been added to ~/.bashrc."
fi

# ====== 完了 ======
SCRIPT_NAME=$(basename "$0")
echo "$SCRIPT_NAME is completed."