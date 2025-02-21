#!/bin/bash

# نمایش منو
echo "Select an option:"
echo "1. Install Warp"
echo "2. Disable Warp"
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        # انتخاب معماری توسط کاربر
        echo "Choose one : (amd64 / arm64) : "
        read ARCH

        # دانلود wgcf بر اساس معماری
        if [ "$ARCH" == "amd64" ]; then
            wget https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_amd64 -O /usr/bin/wgcf
        elif [ "$ARCH" == "arm64" ]; then
            wget https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_arm64 -O /usr/bin/wgcf
        else
            echo "Wrong Arch Type!"
            exit 1
        fi

        # تنظیم مجوز اجرا
        chmod +x /usr/bin/wgcf

        # ثبت‌نام در wgcf
        wgcf register

        # به‌روزرسانی و تولید کانفیگ
        wgcf update
        wgcf generate

        echo "Choose ubuntu : (22 / 24) : "
        read Ubun

        if [ "$Ubun" == "22" ]; then
            sudo apt install wireguard-dkms wireguard-tools resolvconf -y
        elif [ "$Ubun" == "24" ]; then
            sudo apt install wireguard -y
        else
            echo "Wrong Version!"
            exit 1
        fi    

        # اضافه کردن "Table = off" به فایل کانفیگ
        sed -i '/MTU/a Table = off' wgcf-profile.conf

        # انتقال فایل کانفیگ به مسیر مناسب
        mv wgcf-profile.conf /etc/wireguard/warp.conf

        # فعال‌سازی و راه‌اندازی WireGuard
        sudo systemctl enable --now wg-quick@warp

        echo "Installation Successful!"
        echo "Created by Mhdi_TV"
        ;;
    2)
        # غیرفعال کردن Warp
        sudo systemctl disable --now wg-quick@warp
        echo "Warp has been disabled."
        echo "Created by Mhdi_TV"
        ;;
    *)
        echo "Invalid option!"
        exit 1
        ;;
esac
