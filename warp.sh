#!/bin/bash

# انتخاب معماری توسط کاربر
echo "Choose one : (amd64 / arm64) : "
read ARCH

# دانلود wgcf بر اساس معماری
if [ "$ARCH" == "amd64" ]; then
    wget https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_amd64 -O /usr/bin/wgcf
elif [ "$ARCH" == "arm64" ]; then
    wget https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_arm64 -O /usr/bin/wgcf
else
    echo "معماری نامعتبر! لطفاً اسکریپت را دوباره اجرا کرده و مقدار صحیح وارد کنید."
    exit 1
fi

# تنظیم مجوز اجرا
chmod +x /usr/bin/wgcf

# ثبت‌نام در wgcf
wgcf register

# به‌روزرسانی و تولید کانفیگ
wgcf update
wgcf generate

# نصب WireGuard
sudo apt install wireguard -y

# اضافه کردن "Table = off" به فایل کانفیگ
sed -i '/MTU/a Table = off' wgcf-profile.conf

# انتقال فایل کانفیگ به مسیر مناسب
mv wgcf-profile.conf /etc/wireguard/warp.conf

# فعال‌سازی و راه‌اندازی WireGuard
sudo systemctl enable --now wg-quick@warp

echo "نصب و تنظیمات با موفقیت انجام شد!"
