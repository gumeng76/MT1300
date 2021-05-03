#!/bin/bash

############# Modify default parameters here #################
WORKDIR=/workdir
HOSTNAME=MT1300
#IPADDRESS=192.168.8.1
SSID=MT1300
ENCRYPTION=psk2+ccmp
KEY=password
DEFAULT_SETTINGS=/workdir/openwrt/package/lean/default-settings/files/zzz-default-settings
###############################################################

cd "$WORKDIR/openwrt"

# Modify default Hostname
sed -i "s/hostname='OpenWrt'/hostname='$HOSTNAME'/g" package/base-files/files/bin/config_generate

# Modify default IP, can not use this sed command to modify config_generate to change the default network ipaddress in 21.02.
#sed -i 's/192.168.1.1/$IPADDRESS/g' package/base-files/files/bin/config_generate
#if [ -f "$DEFAULT_SETTINGS" ]
#then
#    sed -i -e '/exit 0/d' $DEFAULT_SETTINGS
#    echo 'uci set network.lan.ipaddr=192.168.8.1' >> $DEFAULT_SETTINGS
#    echo 'uci commit network' >> $DEFAULT_SETTINGS
#    echo 'exit 0' >> $DEFAULT_SETTINGS
#fi

# Modify Timezone
sed -i "s/timezone='UTC'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a\                set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# Modify NTP settings
sed -i 's/0.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/time.ustc.edu.cn/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/pool.ntp.org/g' package/base-files/files/bin/config_generate

# Modify default WiFi SSID
sed -i "s/set wireless.default_radio\${devidx}.ssid=OpenWrt/set wireless.default_radio\${devidx}.ssid='$SSID'/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default WiFi Encryption
sed -i "s/set wireless.default_radio\${devidx}.encryption=none/set wireless.default_radio\${devidx}.encryption='$ENCRYPTION'/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default WiFi Key
sed -i "/set wireless.default_radio\${devidx}.mode=ap/a\                        set wireless.default_radio\${devidx}.key='$KEY'" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Forced WiFi to enable
sed -i 's/set wireless.radio\${devidx}.disabled=1/set wireless.radio\${devidx}.disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
