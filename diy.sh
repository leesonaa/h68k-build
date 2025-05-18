#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Modify the version number
#sed -i "s/OpenWrt /OpenWrt build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i uci set network.globals.ula_prefix=\nuci commit network' package/emortal/default-settings/files/99-default-settings-chinese

# Modify default 
#sed -i '/exit 0/i uci set dhcp.lan.ra_dns="0"\nuci commit dhcp' package/emortal/default-settings/files/99-default-settings-chinese  # 关闭ipv6 ra通告dns

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

# add some files
RELEASE="24.10.1"
TARGET="rockchip/armv8"
ARCH="aarch64_generic"
MIRROR="https://mirrors.vsean.net/openwrt/releases"
KMOD_MIRROR="https://mirror.nju.edu.cn/immortalwrt/releases"
KMOD_VERSION="6.6.86-1-422144fea623288f7402e1a9a15724c8"

mkdir -p target/linux/rockchip/armv8/base-files/etc/opkg
cat << EOF > target/linux/rockchip/armv8/base-files/etc/opkg/distfeeds.conf
src/gz immortalwrt_core ${MIRROR}/${RELEASE}/targets/${TARGET}/packages
src/gz immortalwrt_base ${MIRROR}/${RELEASE}/packages/${ARCH}/base
src/gz immortalwrt_luci ${MIRROR}/${RELEASE}/packages/${ARCH}/luci
src/gz immortalwrt_packages ${MIRROR}/${RELEASE}/packages/${ARCH}/packages
src/gz immortalwrt_routing ${MIRROR}/${RELEASE}/packages/${ARCH}/routing
src/gz immortalwrt_telephony ${MIRROR}/${RELEASE}/packages/${ARCH}/telephony
src/gz immortalwrt_kmod ${KMOD_MIRROR}/${RELEASE}/targets/${TARGET}/kmods/${KMOD_VERSION}
EOF

ls -l target/linux/rockchip/armv8/base-files/etc/opkg

mkdir -p target/linux/rockchip/armv8/base-files/usr/lib/opkg
cat << EOF > target/linux/rockchip/armv8/base-files/usr/lib/opkg/status
Package: kmod-nft-tproxy
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nft-core, kmod-nf-tproxy, kmod-nf-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-usb-storage
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-scsi-core, kmod-usb-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: terminfo
Version: 6.4-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-proto-wireguard
Version: 25.116.62431~e7f6f1e
Depends: libc, wireguard-tools, ucode, luci-lib-uqr, resolveip
Status: install user installed
Architecture: all
Installed-Time: 1747564666

Package: libuci-lua
Version: 2025.01.20~16ff0bad-r1
Depends: libc, libuci20250120, liblua5.1.5
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564291
Auto-Installed: yes

Package: sing-box
Version: 1.11.9-r1
Depends: libc, ca-bundle, kmod-inet-diag, kmod-netlink-diag, kmod-tun
Status: install user installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/sing-box 50a2a45e7d14758c3b4c7f34240998b46d30305d3f3ceb1568df84495e3c6f11
 /etc/sing-box/config.json 59aac6f3459d3a48c496ab3055d9a9c261179dd8ad73b54a4dccb9ebf3ae9a5b
Installed-Time: 1747564547

Package: luci-i18n-cpufreq-zh-cn
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-app-cpufreq
Status: install user installed
Architecture: all
Installed-Time: 1747564231

Package: iwinfo
Version: 2024.10.20~b94f066e-r1
Depends: libc, libiwinfo20230701
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libopenssl3
ABIVersion: 3
Version: 3.0.16-r1
Depends: libc
Provides: libopenssl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: openssh-sftp-server
Version: 9.9_p2-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: liblucihttp0
ABIVersion: 0
Version: 2023.03.15~9b5b683f-r1
Depends: libc
Provides: liblucihttp
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-lib-textsearch
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: cgi-io
Version: 2022.08.10~901b0f04-r21
Depends: libc, libubox20240329, libubus20250102
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-lib-base
Version: 25.116.62431~e7f6f1e
Depends: libc, lua, luci-lib-nixio, luci-lib-ip, luci-lib-jsonc, liblucihttp-lua
Status: install user installed
Architecture: all
Installed-Time: 1747564561

Package: libc
Version: 1.2.5-r4
Depends: libgcc
Status: install hold installed
Essential: yes
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-macvlan
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-user
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash, kmod-crypto-manager, kmod-crypto-rng
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: mkf2fs
Version: 1.16.0-r3
Depends: libc, libf2fs6
Conflicts: mkf2fs-selinux
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-gf128
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: opkg
Version: 2024.10.16~38eccbb1-r1
Depends: libc, uclient-fetch, libpthread, libubox20240329
Status: install ok installed
Essential: yes
Architecture: aarch64_generic
Conffiles:
 /etc/opkg.conf f38c19f696ea87c0b30eb5bfeb8657237f4625e1a749c58b99f01595edfb6446
 /etc/opkg/customfeeds.conf 61d1f3aa62fe977614ed0c2f0ad3b2ee2f7b451bfb34812071d86d31a4d43d4a
Installed-Time: 1744717122

Package: libwebsockets-full
Version: 4.3.3-r1
Depends: libc, zlib, libcap, libubox20240329, libopenssl3, libuv1
Provides: libwebsockets, libwebsockets-openssl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-usb-core
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-usb-storage-uas
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-usb-storage
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libpthread
Version: 1.2.5-r4
Depends: libgcc1
Status: install hold installed
Essential: yes
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ubus
Version: 2025.01.02~afa57cce-r1
Depends: libc, libubus20250102, libblobmsg-json20240329, ubusd
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: iw
Version: 6.9-r1
Depends: libc, libnl-tiny1
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-manager
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-aead, kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nft-fullcone
Version: 6.6.86.2023.05.17~07d93b62-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nft-nat
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: rpcd
Version: 2024.09.17~9f4b86e7-r1
Depends: libc, libubus20250102, libubox20240329, libuci20250120, libblobmsg-json20240329, libjson-c5
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/rpcd 1a40da0ebe45b1afd131dfc4650592913e38445e7fe42f96d3b95ad5151ac0e6
Installed-Time: 1744717122
Auto-Installed: yes

Package: busybox
Version: 1.36.1-r2
Depends: libc
Conflicts: busybox-selinux
Status: install ok installed
Essential: yes
Architecture: aarch64_generic
Conffiles:
 /etc/syslog.conf e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
Installed-Time: 1744717122
Auto-Installed: yes

Package: ntfs3-mount
Version: 10
Depends: libc, kmod-fs-ntfs3
Conflicts: ntfs-3g
Status: install ok installed
Architecture: all
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-ctr
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-manager, kmod-crypto-seqiv
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libiwinfo20230701
ABIVersion: 20230701
Version: 2024.10.20~b94f066e-r1
Depends: libc, libnl-tiny1, libuci20250120, libubus20250102, libiwinfo-data
Provides: libiwinfo
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-lib-ip
Version: 25.116.62431~e7f6f1e
Depends: libc, liblua5.1.5, libnl-tiny1
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564568

Package: kmod-hwmon-pwmfan
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-hwmon-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ip-full
Version: 6.11.0-r1
Depends: libc, libnl-tiny1, libbpf1, libmnl0
Provides: ip
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564290
Auto-Installed: yes
Alternatives: 300:/sbin/ip:/usr/libexec/ip-full

Package: kmod-nft-fib
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nft-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nfnetlink
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-ata-ahci-platform
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-ata-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libubus-lua
Version: 2025.01.02~afa57cce-r1
Depends: libc, libubus20250102, liblua5.1.5
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-mt792x-common
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211, kmod-mt76-connac
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-hash
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-reject6
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-netlink-diag
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-tun
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-aead
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-null
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-r8125
Version: 6.6.86.9.015.00-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-libphy
Provides: kmod-r8169, kmod-r8125-rss
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-inet-diag
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: chinadns-ng
Version: 2025.03.27-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564288
Auto-Installed: yes

Package: haproxy
Version: 3.0.10-r1
Depends: libc, libpcre2, libltdl7, zlib, libpthread, liblua5.3-5.3, libopenssl3, libncurses6, libreadline8, libatomic1
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/haproxy.cfg 881de4deabbabad7b7110d27ee9ebfda045431621d54c1d7488cba4c8c050e0a
Installed-Time: 1747564300
Auto-Installed: yes

Package: luci-mod-system
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base
Status: install user installed
Architecture: all
Installed-Time: 1747564649

Package: kmod-nf-flow
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libnl-tiny1
ABIVersion: 1
Version: 2025.03.19~c0df580a-r1
Depends: libc
Provides: libnl-tiny
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-lib-crc-ccitt
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ucode-mod-uloop
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: getrandom
Version: 2024.04.26~85f10530-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ucode-mod-ubus
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode, libubus20250102, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-asn1-decoder
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libustream-openssl20201210
ABIVersion: 20201210
Version: 2024.07.28~99bd3d2b-r1
Depends: libc, libubox20240329, libopenssl3
Provides: libustream-openssl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libev
Version: 4.33-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564304
Auto-Installed: yes

Package: luci-theme-bootstrap
Version: 25.113.44737~d0b983a
Depends: libc, luci-base
Status: install user installed
Architecture: all
Installed-Time: 1747564672

Package: kmod-pppoe
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-ppp, kmod-pppox
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nf-nathelper
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-nat
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libuuid1
ABIVersion: 1
Version: 2.40.2-r1
Depends: libc, librt
Provides: libuuid
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ipt2socks
Version: 1.1.4-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564294
Auto-Installed: yes

Package: libcap
Version: 2.69-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-lua-runtime
Version: 25.120.37759~99d252e
Depends: libc, luci-base, lua, luci-lib-base, luci-lib-nixio, luci-lib-ip, luci-lib-jsonc, libubus-lua, liblucihttp-lua, ucode-mod-lua
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564620

Package: kmod-pppox
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-ppp
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: shellsync
Version: 0.2-r2
Depends: libc, libpthread, kmod-macvlan
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-reject
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: procd-ujail
Version: 2024.12.22~42d39376-r1
Depends: libc, libubox20240329, libubus20250102, libuci20250120, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: base-files
Version: 1856~cc720ea55a71
Depends: libc, netifd, jsonfilter, usign, openwrt-keyring, fstools, fwtool, procd, procd-seccomp, busybox
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/ethers 56bda09b0aa3d1e88107bfa8a1c6e4449d5c1f47245dc1c4037ff9b5db163b7c
 /etc/group 45e8cab268d4a2254d48ccb1f889630047e81758de54a614cad5449fdbebe19c
 /etc/hosts c1a978d90673437b35fa9494e0a54294062c152bb653d490b718052ab88447fd
 /etc/inittab 8b395f7d827753e1e92d4a1c369d9fe16caa23bf742b3f78e4599c4dd9b1b6e3
 /etc/iproute2/rt_protos a0712b1771c8d5f3e0dcf9a6314880e71aa3498ea1ae873535bdfcf70d814061
 /etc/iproute2/rt_tables f771e2b81741f70e3faf658dc504f0dc048672fc8caaadea15e46c35da3de8f8
 /etc/passwd 6a451aa33393f47ade89b8bce4d9711818c2630394c3967265ffed276bb25a55
 /etc/profile fe0a48863c90360cc6924d9b75e791a4b71e2193c74b990171b8313663d13876
 /etc/protocols 7d551355d5540b07b9d86e623cbbc4abecbb94d2a662b3afcc917940eb0e3d52
 /etc/rc.local 515018aa94eb4937dade12dc0d69890b352af35a5ab5fb8203f9ed10990ac06f
 /etc/services 754ccc71ca347bc79ac4c45139d416b7cf1e65a919dad1db15613a216cd6b9cc
 /etc/shadow 9000a74fcbf027301e784909e74e2cfff1b879707432090fadedc8527858873e
 /etc/shells 8b35ce73c18161a7d7ed16fa244410993bd031515260e3e0c11749047df48d0a
 /etc/shinit f633939cdda16a3116225a578f457295b2a0da824c47d5f0e90a58806c059321
 /etc/sysctl.conf fa1403135ff66ed23c1c88163ba06d1d13d6ea9e73201728ae0180b3a6902eca
 /etc/sysupgrade.conf 9e87b05fe2f12c84d1c465b396322748479f64bc40e5bab061887f0bd95020a6
Installed-Time: 1744717122

Package: kmod-lib-crc16
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-nat
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ttyd
Version: 1.7.3-r1
Depends: libc, libcap, libopenssl3, libjson-c5, libuv1, zlib, libwebsockets-full
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/ttyd 1963ea01a8ce7c94fd6353855fb43cca94e9d9e7894531207cf123a6608fe832
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-crc32c
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ucode-mod-uci
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode, libuci20250120
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: coreutils-base64
Version: 9.3-r1
Depends: libc, coreutils
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564284
Auto-Installed: yes
Alternatives: 300:/bin/base64:/usr/libexec/base64-coreutils

Package: ucode-mod-lua
Version: 1
Depends: libc, libucode20230711, liblua5.1.5
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: partx-utils
Version: 2.40.2-r1
Depends: libc, libblkid1, libsmartcols1
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-app-ttyd
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base, ttyd
Status: install ok installed
Architecture: all
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mt7922-firmware
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: netifd
Version: 2024.12.17~ea01ed41-r1
Depends: libc, libuci20250120, libnl-tiny1, libubus20250102, ubus, ubusd, jshn, libubox20240329, libudebug, ucode, ucode-mod-fs
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/udhcpc.user 4dabffbc2110a29e01babc63d9b8db94da49efd3ed784d35b49a559ac8ce7035
Installed-Time: 1744717122
Auto-Installed: yes

Package: coreutils
Version: 9.3-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564284
Auto-Installed: yes

Package: libf2fs6
ABIVersion: 6
Version: 1.16.0-r3
Depends: libc, libuuid1
Provides: libf2fs
Conflicts: libf2fs-selinux
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libsmartcols1
ABIVersion: 1
Version: 2.40.2-r1
Depends: libc, librt
Provides: libsmartcols
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: firewall4
Version: 2024.12.18~18fc0ead-r1
Depends: ucode (>= 2022.03.22), libc, kmod-nft-core, kmod-nft-fib, kmod-nft-offload, kmod-nft-nat, kmod-nft-fullcone, nftables-json, ucode, ucode-mod-fs, ucode-mod-ubus, ucode-mod-uci
Provides: uci-firewall
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/firewall d28a3d6143076b86bece65f4bdf9f5dc5d80c6b6cbb5da7c2e28594d57f0839a
 /etc/nftables.d/10-custom-filter-chains.nft af5cbfeb3e3b61d32ce134ae33d15330ee27da838e6f4fb9c717f034923b8b16
 /etc/nftables.d/README 0656d83221c1d000f6b9655757c412f328e332b5bdf25efbfa88611d8104490d
Installed-Time: 1744717122
Auto-Installed: yes

Package: uboot-envtools
Version: 2024.07-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: procd
Version: 2024.12.22~42d39376-r1
Depends: libc, ubusd, ubus, libjson-script20240329, ubox, libubox20240329, libudebug, libubus20250102, libblobmsg-json20240329, libjson-c5, jshn
Conflicts: procd-selinux
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: resolveip
Version: 2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-hmac
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash, kmod-crypto-manager
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-i18n-homeproxy-zh-cn
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-app-homeproxy
Status: install user installed
Architecture: all
Installed-Time: 1747564232

Package: libbpf1
ABIVersion: 1
Version: 1.5.0-r1
Depends: libc, libelf1
Provides: libbpf
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564290
Auto-Installed: yes

Package: autocore
Version: 42
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ubusd
Version: 2025.01.02~afa57cce-r1
Depends: libc, libubox20240329, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libnetfilter-conntrack3
ABIVersion: 3
Version: 1.0.9-r2
Depends: libc, libnfnetlink0, kmod-nf-conntrack-netlink, libmnl0
Provides: libnetfilter-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: shadowsocks-rust-ssserver
Version: 1.23.2-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564304
Auto-Installed: yes

Package: rpcd-mod-ucode
Version: 2024.09.17~9f4b86e7-r1
Depends: libc, libubus20250102, libubox20240329, rpcd, libucode20230711
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ucode-mod-math
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: dns2socks
Version: 2.1-r2
Depends: libc, libpthread
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564288
Auto-Installed: yes

Package: kmod-lib-crc32c
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-crc32c
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libelf1
ABIVersion: 1
Version: 0.192-r1
Depends: libc, zlib
Provides: libelf, libelf11
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564289
Auto-Installed: yes

Package: libubus20250102
ABIVersion: 20250102
Version: 2025.01.02~afa57cce-r1
Depends: libc, libubox20240329
Provides: libubus
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-mod-status
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base, libiwinfo20230701, rpcd-mod-iwinfo
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564641

Package: kmod-crypto-sha512
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mt76-connac
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211, kmod-mt76-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: block-mount
Version: 2024.07.14~408c2cc4-r1
Depends: libc, ubox, libubox20240329, libuci20250120, libblobmsg-json20240329, libjson-c5, fstools
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: automount
Version: 10
Depends: libc, block-mount, e2fsprogs, kmod-usb-storage, kmod-usb-storage-extras, kmod-usb-storage-uas, kmod-fs-ext4, kmod-fs-exfat, kmod-fs-vfat, ntfs3-mount
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: kmod-crypto-seqiv
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-aead, kmod-crypto-rng, kmod-crypto-geniv
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-fs-vfat
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base, kmod-nls-cp437, kmod-nls-iso8859-1, kmod-nls-utf8
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nft-nat
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nft-core, kmod-nf-nat
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-lib-chacha20poly1305
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-lib-chacha20, kmod-crypto-lib-poly1305
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-fs-exfat
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-lib-poly1305
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libopenssl-legacy
Version: 3.0.16-r1
Depends: libc, libopenssl3, libopenssl-conf
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/ssl/modules.cnf.d/legacy.cnf 44772f93dd6faec414b8921b1da7ef5337086dc123a48d5bed6e2b9e4552ce6e
Installed-Time: 1744717122

Package: luci-app-cpufreq
Version: 25.116.62431~e7f6f1e
Depends: libc, cpufreq
Status: install user installed
Architecture: all
Installed-Time: 1747564503

Package: luci-app-firewall
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base, uci-firewall
Status: install user installed
Architecture: all
Installed-Time: 1747564524

Package: luci-lib-ipkg
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base, luci-lua-runtime
Status: install user installed
Architecture: all
Installed-Time: 1747564574

Package: libblkid1
ABIVersion: 1
Version: 2.40.2-r1
Depends: libc, libuuid1
Provides: libblkid
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libmnl0
ABIVersion: 0
Version: 1.0.5-r1
Depends: libc
Provides: libmnl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: jansson4
ABIVersion: 4
Version: 2.14-r3
Depends: libc
Provides: jansson
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: v2ray-plugin
Version: 5.25.0-r1
Depends: libc, ca-bundle
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564310
Auto-Installed: yes

Package: wpad-openssl
Version: 2024.09.15~5ace39b0-r2
Depends: hostapd-common (= 2024.09.15~5ace39b0-r2), libc, libnl-tiny1, hostapd-common, ucode, libucode20230711, ucode-mod-fs, ucode-mod-nl80211, ucode-mod-rtnl, ucode-mod-ubus, ucode-mod-uloop, libubus20250102, libblobmsg-json20240329, libudebug, libopenssl3, libopenssl-legacy
Provides: hostapd, wpa-supplicant
Conflicts: hostapd, hostapd-basic, hostapd-basic-openssl, hostapd-basic-wolfssl, hostapd-basic-mbedtls, hostapd-mini, hostapd-openssl, hostapd-wolfssl, hostapd-mbedtls, wpad, wpad-mesh-openssl, wpad-mesh-wolfssl, wpad-mesh-mbedtls, wpad-basic, wpad-basic-openssl, wpad-basic-wolfssl, wpad-basic-mbedtls, wpad-mini, wpad, wpad-mesh-openssl, wpad-mesh-wolfssl, wpad-mesh-mbedtls, wpad-basic, wpad-basic-openssl, wpad-basic-wolfssl, wpad-basic-mbedtls, wpad-mini
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/radius bef62a785544c390592e7626153135a5b7af0ce863e63c57c098cef75991d201
 /etc/radius/clients fbb33c7cae037be801aa89912ec835397c6f7f8c2ac1c6526857d17da865e2ab
 /etc/radius/users 0a9b818ca14c9a87f23a1455530a6941eb63878724386d820b6ecacd0eeeb935
Installed-Time: 1744717122

Package: ethtool-full
Version: 6.11-r1
Depends: libc, libmnl0
Provides: ethtool
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nf-socket
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564295
Auto-Installed: yes

Package: odhcp6c
Version: 2024.09.25~b6ae9ffa-r1
Depends: libc, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/odhcp6c.user 6d2b77cbb3ff311ea6e7237fe150bf272bf0b3a6c0b4e9e00c6423fd6b637557
Installed-Time: 1744717122

Package: fstools
Version: 2024.07.14~408c2cc4-r1
Depends: libc, ubox
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: uclient-fetch
Version: 2024.10.22~88ae8f20-r1
Depends: libc, libuclient20201210
Provides: wget
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Alternatives: 200:/usr/bin/wget:/bin/uclient-fetch

Package: kmod-udptunnel4
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-udptunnel6
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-ghash
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-gf128, kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: unzip
Version: 6.0-r8
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564294
Auto-Installed: yes

Package: kmod-nft-socket
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nft-core, kmod-nf-socket
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564295
Auto-Installed: yes

Package: uci
Version: 2025.01.20~16ff0bad-r1
Depends: libc, libuci20250120
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: lua
Version: 5.1.5-r11
Depends: libc, liblua5.1.5
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-fs-ext4
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-lib-crc16, kmod-crypto-hash, kmod-crypto-crc32c
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ucode-mod-fs
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: dropbear
Version: 2024.86-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/dropbear 63b8d3501f4b993f9f3fa486af8506a9fc227ad3dc7756b97cf98f01b7c4108f
Installed-Time: 1744717122
Alternatives: 100:/usr/bin/ssh-keygen:/usr/sbin/dropbear, 100:/usr/bin/scp:/usr/sbin/dropbear, 100:/usr/bin/ssh:/usr/sbin/dropbear

Package: luci-theme-argon
Version: 2.4.2-r20250207
Depends: libc, wget, jsonfilter, luci-lua-runtime
Status: install user installed
Architecture: all
Conffiles:
 /www/luci-static/argon/background/README.md bda8c280f3c3f0493b69f4c826924d5048f1fce715d366aa026c023ff8a9042e
Installed-Time: 1747564143

Package: kmod-mt7921e
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211, kmod-mt7921-common
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libpcre2
Version: 10.42-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564296
Auto-Installed: yes

Package: curl
Version: 8.10.1-r1
Depends: libc, libcurl4
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564287
Auto-Installed: yes

Package: kmod-hwmon-core
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nls-utf8
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libnftnl11
ABIVersion: 11
Version: 1.2.8-r1
Depends: libc, libmnl0
Provides: libnftnl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libgmp10
ABIVersion: 10
Version: 6.3.0-r1
Depends: libc
Provides: libgmp
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: microsocks
Version: 1.0.4-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/microsocks e8227140fefe6b7722397079ffc191c4797e079ed7f09746b1cd6ea80aa1796d
Installed-Time: 1747564292
Auto-Installed: yes

Package: luci-compat
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-lua-runtime, luci-lua-runtime
Status: install user installed
Architecture: all
Installed-Time: 1747564554

Package: rpcd-mod-file
Version: 2024.09.17~9f4b86e7-r1
Depends: libc, libubus20250102, libubox20240329, rpcd
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nls-cp437
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: mtd
Version: 26
Depends: libc, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: odhcpd-ipv6only
Version: 2024.05.08~a2988231-r2
Depends: libc, libubox20240329, libuci20250120, libubus20250102, libnl-tiny1
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: procd-seccomp
Version: 2024.12.22~42d39376-r1
Depends: libc, libubox20240329, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ucode-mod-nl80211
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode, libnl-tiny1, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mt7921-common
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211, kmod-mt792x-common, kmod-mt7921-firmware, kmod-mt7922-firmware, kmod-hwmon-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libjson-script20240329
ABIVersion: 20240329
Version: 2024.03.29~eb9bcb64-r1
Depends: libc, libubox20240329
Provides: libjson-script
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libiwinfo-data
Version: 2024.10.20~b94f066e-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ucode
Version: 2025.02.10~a8a11aea-r1
Depends: libc, libucode20230711
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: rpcd-mod-luci
Version: 20240305-r1
Depends: libc, rpcd, libubox20240329, libubus20250102, libnl-tiny1
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-ccm
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-ctr, kmod-crypto-aead
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nf-log
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-app-package-manager
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base
Provides: luci-app-opkg
Status: install user installed
Architecture: all
Installed-Time: 1747564511

Package: libuci20250120
ABIVersion: 20250120
Version: 2025.01.20~16ff0bad-r1
Depends: libc, libubox20240329
Provides: libuci
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: urandom-seed
Version: 3
Depends: libc, getrandom
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-i18n-package-manager-zh-cn
Version: 25.114.56694~3255132
Depends: libc, luci-app-package-manager
Status: install user installed
Architecture: all
Installed-Time: 1747564233

Package: luci-proto-ppp
Version: 25.116.62431~e7f6f1e
Depends: libc
Status: install user installed
Architecture: all
Installed-Time: 1747564659

Package: libcomerr0
ABIVersion: 0
Version: 1.47.0-r2
Depends: libc, libuuid1
Provides: libcomerr
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ppp
Version: 2.5.1-r1
Depends: libc, kmod-ppp, libpthread, shellsync, kmod-mppe
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/ppp/chap-secrets 6981fa176a79f8c12be5826c421b16253a616747018ba7e76752a9d36d1d51d4
 /etc/ppp/filter 579583b318e0cff706ffc134620b42d3fbce8fc31aeb0ad7eea1cc859868e902
 /etc/ppp/options 01f7358a5528be037dde329a2ecfb7a63382aababf21d4f5bc085f5acef95133
Installed-Time: 1744717122

Package: luci-mod-admin-full
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-base, luci-mod-status, luci-mod-system, luci-mod-network
Status: install user installed
Architecture: all
Installed-Time: 1747564627

Package: luci-base
Version: 25.120.37759~99d252e
Depends: libc, rpcd, rpcd-mod-file, rpcd-mod-luci, rpcd-mod-ucode, cgi-io, ucode, ucode-mod-fs, ucode-mod-uci, ucode-mod-ubus, ucode-mod-math, ucode-mod-html, liblucihttp-ucode
Status: install user installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/luci 60078f7c02ed91d23092c9b75cb9ea5c8ee39f7727def813c8201f8e48a296f4
 /etc/luci-uploads/.placeholder e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
Installed-Time: 1747564531

Package: libnettle8
ABIVersion: 8
Version: 3.9.1-r1
Depends: libc, libgmp10
Provides: libnettle
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-gpio-button-hotplug
Version: 6.6.86-r5
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: logd
Version: 2024.04.26~85f10530-r1
Depends: libc, libubox20240329, libubus20250102, libblobmsg-json20240329, libudebug
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Alternatives: 200:/sbin/logread:/usr/libexec/logread-ubox

Package: kmod-nf-log6
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-log
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libreadline8
ABIVersion: 8
Version: 8.2-r2
Depends: libc, libncursesw6
Provides: libreadline
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564298
Auto-Installed: yes

Package: librt
Version: 1.2.5-r4
Depends: libpthread
Status: install hold installed
Essential: yes
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-wireguard
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-lib-chacha20poly1305, kmod-crypto-lib-curve25519, kmod-udptunnel4, kmod-udptunnel6
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: shadowsocks-rust-sslocal
Version: 1.23.2-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564302
Auto-Installed: yes

Package: wifi-scripts
Version: 1.0-r1
Depends: libc, netifd, ucode, ucode-mod-nl80211, ucode-mod-rtnl, ucode-mod-ubus, ucode-mod-uci
Status: install ok installed
Architecture: all
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mac80211
Version: 6.6.86.6.12.6-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-cfg80211, kmod-crypto-cmac, kmod-crypto-ccm, kmod-crypto-gcm, hostapd-common
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: wireguard-tools
Version: 1.0.20210914-r4
Depends: libc, ip, ip, kmod-wireguard
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: cpufreq
Version: 1
Depends: libc
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: luci-proto-ipv6
Version: 25.116.62431~e7f6f1e
Depends: libc
Status: install user installed
Architecture: all
Installed-Time: 1747564654

Package: kmod-fs-ntfs3
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: simple-obfs-client
Version: 0.0.5-r2
Depends: libc, libpthread, libev
Provides: simple-obfs
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564305
Auto-Installed: yes

Package: kmod-crypto-ecb
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-manager
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: openwrt-keyring
Version: 2024.11.01~c5d6bdf2-r1
Depends: libc
Provides: lede-keyring
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-conntrack-netlink
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nfnetlink, kmod-nf-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-geniv
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-rng, kmod-crypto-aead
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-libphy
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libext2fs2
ABIVersion: 2
Version: 1.47.0-r2
Depends: libc, libuuid1, libblkid1, libss2, libcomerr0
Provides: libext2fs
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-nathelper-extra
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-nat, kmod-lib-textsearch, kmod-asn1-decoder
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: jshn
Version: 2024.03.29~eb9bcb64-r1
Depends: libc, libjson-c5, libubox20240329, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: nftables-json
Version: 1.1.1-r1
Depends: libc, kmod-nft-core, libnftnl11, jansson4
Provides: nftables
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libfdisk1
ABIVersion: 1
Version: 2.40.2-r1
Depends: libc, libuuid1, libblkid1
Provides: libfdisk
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: e2fsprogs
Version: 1.47.0-r2
Depends: libc, libuuid1, libext2fs2, libe2p2
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/e2fsck.conf dece11e2b15f487d7d2bf9f96abe2eaaf9cd33f02d7b9725b9116023d7786cac
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-ata-core
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-scsi-core
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nft-offload
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-flow, kmod-nft-nat
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-ppp
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-lib-crc-ccitt, kmod-slhc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libopenssl-conf
Version: 3.0.16-r1
Depends: libc, libopenssl3
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/ssl/openssl.cnf 39543707097e57d618dd8ad2a99a3f382422b542fa060b071cb0bd0f655d8974
Installed-Time: 1744717122

Package: libncurses6
ABIVersion: 6
Version: 6.4-r2
Depends: libc, terminfo
Provides: libncursesw, libncurses, libncursesw6
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-null
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ip-tiny
Version: 6.11.0-r1
Depends: libc, libnl-tiny1
Provides: ip
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Alternatives: 200:/sbin/ip:/usr/libexec/ip-tiny

Package: libss2
ABIVersion: 2
Version: 1.47.0-r2
Depends: libc, libcomerr0
Provides: libss
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libjson-c5
ABIVersion: 5
Version: 0.18-r1
Depends: libc
Provides: libjson-c
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: uhttpd
Version: 2023.06.25~34a8a74d-r4
Depends: libc, libubox20240329, libblobmsg-json20240329, libjson-script20240329, libjson-c5
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/uhttpd 4e5df10abae8fb8da99ef022914c09ea13d9bf77fa9ce774124c879bef31c513
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nf-conntrack
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libcurl4
ABIVersion: 4
Version: 8.10.1-r1
Depends: libc, libopenssl3, libpthread, libnghttp2-14, ca-bundle
Provides: libcurl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564286
Auto-Installed: yes

Package: default-settings
Version: 29
Depends: libc, luci
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: usign
Version: 2020.05.23~f1f65026-r1
Depends: libc, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: default-settings-chn
Version: 29
Depends: libc, default-settings, luci-i18n-base-zh-cn
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: liblua5.1.5
ABIVersion: 5.1.5
Version: 5.1.5-r11
Depends: libc
Provides: liblua
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: zlib
Version: 1.3.1-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: liblua5.3-5.3
ABIVersion: -5.3
Version: 5.3.5-r6
Depends: libc
Provides: liblua5.3
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564297
Auto-Installed: yes

Package: luci-app-homeproxy
Version: 25.116.62431~e7f6f1e
Depends: libc, sing-box, firewall4, kmod-nft-tproxy
Status: install user installed
Architecture: all
Conffiles:
 /etc/config/homeproxy 9a029a3c9eb90a94a078408ea9d6f671d58a0912a9b9e89ed09cbbd9ea3dd87e
Installed-Time: 1747564493

Package: luci-i18n-ttyd-zh-cn
Version: 25.114.56694~3255132
Depends: libc, luci-app-ttyd
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: libblobmsg-json20240329
ABIVersion: 20240329
Version: 2024.03.29~eb9bcb64-r1
Depends: libc, libjson-c5, libubox20240329
Provides: libblobmsg-json
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-i18n-passwall-zh-cn
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-app-passwall
Status: install user installed
Architecture: all
Installed-Time: 1747564321

Package: kmod-crypto-gcm
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-ctr, kmod-crypto-ghash, kmod-crypto-null
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-lib-nixio
Version: 25.116.62431~e7f6f1e
Depends: libc, liblua5.1.5
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564585

Package: ucode-mod-rtnl
Version: 2025.02.10~a8a11aea-r1
Depends: libc, ucode, libnl-tiny1, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ca-bundle
Version: 20241223-r1
Depends: libc
Provides: ca-certs
Status: install ok installed
Architecture: all
Installed-Time: 1744717122

Package: luci-i18n-base-zh-cn
Version: 25.120.37759~99d252e
Depends: libc, luci-base
Status: install user installed
Architecture: all
Installed-Time: 1747564233

Package: libuclient20201210
ABIVersion: 20201210
Version: 2024.10.22~88ae8f20-r1
Depends: libc, libubox20240329
Provides: libuclient
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: liblucihttp-lua
Version: 2023.03.15~9b5b683f-r1
Depends: libc, liblucihttp0, liblua5.1.5
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-nls-iso8859-1
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nls-base
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-cmac
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-lib-jsonc
Version: 25.116.62431~e7f6f1e
Depends: libc, liblua5.1.5, libjson-c5
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564579

Package: ucode-mod-html
Version: 1
Depends: libc, libucode20230711
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: tcping
Version: 0.3-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564292
Auto-Installed: yes

Package: luci
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-light, luci-app-package-manager
Status: install user installed
Architecture: all
Installed-Time: 1747564463

Package: kmod-crypto-rng
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash, kmod-crypto-hmac, kmod-crypto-sha512, kmod-crypto-sha3
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: fdisk
Version: 2.40.2-r1
Depends: libc, libblkid1, libsmartcols1, libfdisk1, libncursesw6
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nf-conntrack6
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nf-conntrack
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-light
Version: 25.116.62431~e7f6f1e
Depends: libc, luci-proto-ipv6, luci-app-firewall, luci-mod-admin-full, luci-proto-ppp, luci-theme-bootstrap, rpcd-mod-rrdns, uhttpd, uhttpd-mod-ubus
Status: install user installed
Architecture: all
Installed-Time: 1747564613

Package: libgcc1
ABIVersion: 1
Version: 13.3.0-r4
Provides: libgcc
Status: install hold installed
Essential: yes
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: geoview
Version: 0.1.9-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564307
Auto-Installed: yes

Package: kmod-crypto-lib-curve25519
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-lib-uqr
Version: 25.116.62431~e7f6f1e
Depends: libc
Status: install user installed
Architecture: all
Installed-Time: 1747564590

Package: kmod-mt76-core
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: ubox
Version: 2024.04.26~85f10530-r1
Depends: libc, libubox20240329, ubusd, ubus, libubus20250102, libuci20250120
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/modules.conf 83dab538976e37112de89ad9569f77410553bd0a8393d19ed656353218ccf6ae
Installed-Time: 1744717122
Auto-Installed: yes
Alternatives: 100:/sbin/rmmod:/sbin/kmodloader, 100:/sbin/insmod:/sbin/kmodloader, 100:/sbin/lsmod:/sbin/kmodloader, 100:/sbin/modinfo:/sbin/kmodloader, 100:/sbin/modprobe:/sbin/kmodloader

Package: kernel
Version: 6.6.86~422144fea623288f7402e1a9a15724c8-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-lib-chacha20
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: rpcd-mod-iwinfo
Version: 2024.09.17~9f4b86e7-r1
Depends: libiwinfo (>= 2023.01.21), libc, libubus20250102, libubox20240329, rpcd, libiwinfo20230701
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: luci-mod-network
Version: 25.120.37759~99d252e
Depends: libc, luci-base, rpcd-mod-iwinfo
Status: install user installed
Architecture: all
Installed-Time: 1747564634

Package: kmod-nft-core
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-nfnetlink, kmod-nf-reject, kmod-nf-reject6, kmod-nf-conntrack6, kmod-nf-nat, kmod-nf-log, kmod-nf-log6, kmod-lib-crc32c
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libucode20230711
ABIVersion: 20230711
Version: 2025.02.10~a8a11aea-r1
Depends: libc, libjson-c5
Provides: libucode
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libltdl7
ABIVersion: 7
Version: 2.4.7-r1
Depends: libc
Provides: libltdl
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564296
Auto-Installed: yes

Package: libatomic1
ABIVersion: 1
Version: 13.3.0-r4
Depends: libgcc1
Provides: libatomic
Status: install hold installed
Essential: yes
Architecture: aarch64_generic
Installed-Time: 1747564298
Auto-Installed: yes

Package: kmod-usb-storage-extras
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-usb-storage
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mppe
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-ppp, kmod-crypto-arc4, kmod-crypto-sha1, kmod-crypto-ecb
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-nls-base
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libnfnetlink0
ABIVersion: 0
Version: 1.0.2-r1
Depends: libc
Provides: libnfnetlink
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: uhttpd-mod-ubus
Version: 2023.06.25~34a8a74d-r4
Depends: libc, uhttpd, libubus20250102, libblobmsg-json20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: fwtool
Version: 2019.11.12~8f7fe925-r1
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: jsonfilter
Version: 2025.04.18~8a86fb78-r1
Depends: libc, libubox20240329, libjson-c5
Status: install user installed
Architecture: aarch64_generic
Installed-Time: 1747564517

Package: liblucihttp-ucode
Version: 2023.03.15~9b5b683f-r1
Depends: libc, liblucihttp0, libucode20230711
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: hostapd-common
Version: 2024.09.15~5ace39b0-r2
Depends: libc
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libubox20240329
ABIVersion: 20240329
Version: 2024.03.29~eb9bcb64-r1
Depends: libc
Provides: libubox
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libe2p2
ABIVersion: 2
Version: 1.47.0-r2
Depends: libc, libuuid1
Provides: libe2p
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-arc4
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-user
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libudebug
Version: 2023.12.06~6d3f51f9
Depends: libc, libubox20240329, libubus20250102
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: libuv1
ABIVersion: 1
Version: 1.48.0-r1
Depends: libc, libpthread, librt
Provides: libuv
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-crypto-sha1
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-crypto-sha3
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-crypto-hash
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-mt7921-firmware
Version: 6.6.86.2025.02.14~e5fef138-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-mac80211
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: wireless-regdb
Version: 2025.02.20-r1
Depends: libc
Status: install ok installed
Architecture: all
Installed-Time: 1744717122
Auto-Installed: yes

Package: urngd
Version: 2023.11.01~44365eb1-r1
Depends: libc, libubox20240329
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-scsi-core
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: kmod-slhc
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), kmod-lib-crc-ccitt
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: kmod-cfg80211
Version: 6.6.86.6.12.6-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1), iw, iwinfo, wifi-scripts, wireless-regdb
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-i18n-firewall-zh-cn
Version: 25.120.37759~99d252e
Depends: libc, luci-app-firewall
Status: install user installed
Architecture: all
Installed-Time: 1747564232

Package: rpcd-mod-rrdns
Version: 20170710
Depends: libc, rpcd, libubox20240329, libubus20250102
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122
Auto-Installed: yes

Package: ppp-mod-pppoe
Version: 2.5.1-r1
Depends: libc, kmod-pppoe
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: luci-app-passwall
Version: 25.4.20-r1
Depends: libc, coreutils, coreutils-base64, coreutils-nohup, curl, chinadns-ng, dns2socks, ip-full, libuci-lua, lua, luci-compat, luci-lib-jsonc, microsocks, resolveip, tcping, unzip, ipt2socks, kmod-nft-socket, kmod-nft-tproxy, kmod-nft-nat, haproxy, shadowsocks-rust-sslocal, shadowsocks-rust-ssserver, simple-obfs, sing-box, geoview, v2ray-plugin, xray-core, luci-lua-runtime
Status: install ok installed
Architecture: all
Conffiles:
 /etc/config/passwall_server c8b59c39f471e4d8e5d242805a08cf8138cfa363b623ba982880e0617a4bcbf4
 /usr/share/passwall/rules/block_host e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
 /usr/share/passwall/rules/block_ip e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
 /usr/share/passwall/rules/direct_host e1493426b2f8daf41cfe017b337e7179386a4f1fe0493884bf5c32f0d63338f4
 /usr/share/passwall/rules/direct_ip 995a06503aabd570e0d2f141fd11ef2ffadbc4b7773fdc299d67756ba559bc76
 /usr/share/passwall/rules/domains_excluded f55fa460dfe7dbfa89897de59c140ed8a0a4b25f11615f9032f5adce1ed8d22c
 /usr/share/passwall/rules/lanlist_ipv4 1dc144fd92ac3e6a0366823b99ad9489c5cffce0ab63fb500fb0e856a4380c3e
 /usr/share/passwall/rules/lanlist_ipv6 a86070ac7b6473584e93383c5b63bec497a5dc5ba3ec9475ee1ff5b7bed43d83
 /usr/share/passwall/rules/proxy_host 53e78c7a6bd59f7c93c6c17cc795c9f15143189e47d2d86278da2fadf32c8c74
 /usr/share/passwall/rules/proxy_ip cc237d89c6c4f9abdd753c67b041d5cc1e9e17c483e19465efa4d7e5c9fad266
 /www/luci-static/resources/qrcode.min.js 73fc488bd39e9e4d835de5395eda593e32a446cb3f0faf5df023f2265ae4b496
Installed-Time: 1747564321
Auto-Installed: yes

Package: kmod-nf-tproxy
Version: 6.6.86-r1
Depends: kernel (= 6.6.86~422144fea623288f7402e1a9a15724c8-r1)
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1744717122

Package: libnghttp2-14
ABIVersion: -14
Version: 1.63.0-r1
Depends: libc
Provides: libnghttp2
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564286
Auto-Installed: yes

Package: coreutils-nohup
Version: 9.3-r1
Depends: libc, coreutils
Status: install ok installed
Architecture: aarch64_generic
Installed-Time: 1747564285
Auto-Installed: yes
Alternatives: 300:/usr/bin/nohup:/usr/libexec/nohup-coreutils

Package: dnsmasq-full
Version: 2.90-r4
Depends: libc, libubus20250102, libnettle8, libnetfilter-conntrack3, nftables-json
Provides: dnsmasq
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/dhcp caa0edd58fd47496535e93c24684c46f45bfd3906e301ab6445c8e3cf2d063c9
 /etc/dnsmasq.conf 1e6ab19c1ae5e70d609ac7b6246541d52042e4dee1892f825266507ef52d7dfd
Installed-Time: 1744717122

Package: xray-core
Version: 25.2.21-r1
Depends: libc, ca-bundle
Status: install ok installed
Architecture: aarch64_generic
Conffiles:
 /etc/config/xray e6bd2628c19db0c34406ea06c19c458316758d265ce951d730a4c0e961ad50fe
 /etc/xray/config.json.example 779d2fb90f77010b408b783013252f8f67a946ad10e613f7556445e472a965c4
Installed-Time: 1747564320
Auto-Installed: yes
EOF

