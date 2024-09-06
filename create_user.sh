#!/bin/bash
set -e
set -x
# 检查是否以root用户运行脚本
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用root权限运行此脚本。"
  exit 1
fi

# 检查参数是否完整
if [ "$#" -lt 2 ]; then
  echo "用法: $0 用户名 密码 rsa文件名 remark"
  exit 1
fi

# 获取脚本参数
username=$1
password=$2
file_name=${3:-'id_rsa'}
remark=${4:-'"'$username'"'}

# 创建用户并设置密码
if [ $username = "root" ]; then
  echo ""
else
  if getent passwd "$username" > /dev/null 2>&1; then
    echo "User $username exists"
  else
      useradd -m "$username"
  fi
fi
echo "$username:$password" | chpasswd



if [ $username = "root" ]; then
    ssh_dir="/root/.ssh"
else
    ssh_dir="/home/$username/.ssh"
fi


# 创建SSH目录并设置权限
su - "$username" -c "mkdir -p $ssh_dir && chmod 700 $ssh_dir"


# 生成SSH密钥对
ssh-keygen -t rsa -b 4096 -f "$ssh_dir/$file_name" -N "" -C "$remark"

# 将公钥添加到authorized_keys
su - "$username" -c "cat $ssh_dir/$file_name.pub >> $ssh_dir/authorized_keys"
su - "$username" -c "chmod 600 $ssh_dir/authorized_keys"

# 输出私钥路径和内容
echo "SSH私钥路径: $ssh_dir/$file_name"
echo "请妥善保管以下SSH私钥内容:"
echo "$ssh_dir/$file_name"
echo "公钥"
cat "$ssh_dir/$file_name.pub"

# 脚本结束
echo "用户 $username 创建完成，并生成SSH密钥对。"

set +e
set +x