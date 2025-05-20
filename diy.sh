#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Modify the version number
#sed -i "s/OpenWrt /OpenWrt build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i uci set network.globals.ula_prefix=\nuci commit network' package/emortal/default-settings/files/99-default-settings-chinese

# Modify default 
#sed -i '/exit 0/i uci set dhcp.lan.ra_dns="0"\nuci commit dhcp' package/emortal/default-settings/files/99-default-settings-chinese  # 关闭ipv6 ra通告dns

# chang abi
cat << EOF > package/base-files/files/etc/uci-defaults/99-change-abi 
#! /bin/sh
if [ -f "/usr/lib/opkg/status" ]; then
  sed -i -E '/6\.6\.86~/s/([^[:space:]]*~)([^-]+)(-.*)/\1422144fea623288f7402e1a9a15724c8\3/' /usr/lib/opkg/status
fi
EOF

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argon/g' feeds/luci/modules/luci-base/root/etc/config/luci


# Modify maximum connections
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf


# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="OpenWrt"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"OpenWrt"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config

# add komod addr
mkdir -p target/linux/rockchip/armv8/base-files/etc/opkg
cat << EOF > target/linux/rockchip/armv8/base-files/etc/opkg/distfeeds.conf
src/gz immortalwrt_kmod https://mirror.nju.edu.cn/immortalwrt/releases/24.10.1/targets/rockchip/armv8/kmods/6.6.86-1-422144fea623288f7402e1a9a15724c8
EOF


