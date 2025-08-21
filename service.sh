#!/system/bin/sh
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Reinstate UI/Render props that can be reset
setprop debug.hwui.renderer skiagl
setprop debug.hwui.disable_vsync true

# Networking TCP stack boosts
setprop net.ipv4.tcp_rmem "4096 87380 16777216"
setprop net.ipv4.tcp_wmem "4096 65536 16777216"
setprop net.ipv4.tcp_congestion_control bbr
setprop net.ipv4.tcp_fin_timeout 10
setprop net.ipv4.tcp_keepalive_time 120

# RNG sysctls
echo 512 > /proc/sys/kernel/random/read_wakeup_threshold
echo 256 > /proc/sys/kernel/random/write_wakeup_threshold
echo 60  > /proc/sys/kernel/random/urandom_min_reseed_secs

# Read-ahead for common devices
for path in \
    /sys/block/mmcblk0/queue/read_ahead_kb \
    /sys/block/mmcblk0rpmb/queue/read_ahead_kb \
    /sys/block/dm-0/queue/read_ahead_kb; do
    [ -e "$path" ] && echo 256 > "$path"
done
