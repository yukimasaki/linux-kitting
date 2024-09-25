#!/bin/bash

# ====== .envファイルを読み込む ======
# .envファイルが存在しない場合は処理を終了
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found. Please create it."
  exit 1
fi

# 値がセットされていない場合は処理を終了
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$SSH_PORT" ]; then
  echo "Variables are not set in the .env file."
  exit 1
fi

# ====== ユーザー作成とsudo権限の付与 ======
# ユーザー作成
useradd -m -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

# ユーザーにsudo権限を付与
usermod -aG sudo $USERNAME

# ====== SSH公開鍵認証の設定 ======
# SSHディレクトリの作成と権限の設定
mkdir -p /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh

# SSH鍵ペアの生成 (ユーザーの権限で実行)
ssh-keygen -t ed25519 -f /home/$USERNAME/.ssh/id_ed25519 -N ""

# 公開鍵をauthorized_keysに追記
cat /home/$USERNAME/.ssh/id_ed25519.pub >> /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# SSHサーバー設定の変更 (公開鍵認証を有効化)
sed -i "s/^#\?PasswordAuthentication \(yes\|no\)/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/^#\?PubkeyAuthentication \(yes\|no\)/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/^#\?PermitRootLogin \(yes\|no\)/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/^#\?Port [0-9]\+/Port $SSH_PORT/" /etc/ssh/sshd_config

systemctl reload sshd

# 秘密鍵の表示（コピペ用）
echo -e "\n\033[1;33m=== Copy this private key and store it securely ===\033[0m"
cat /home/$USERNAME/.ssh/id_ed25519
echo -e "\n\033[1;33m=== Copy this private key and store it securely ===\033[0m"

# キーペアを削除
rm /home/$USERNAME/.ssh/id_ed25519 /home/$USERNAME/.ssh/id_ed25519.pub

# .sshディレクトリの所有権を変更
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

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