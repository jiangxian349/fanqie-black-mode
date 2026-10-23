#!/system/bin/sh
cp $(pm path com.dragon.read.oversea.gp | head -1 | sed 's/package://') /data/local/tmp/base_gate.apk
chmod 644 /data/local/tmp/base_gate.apk
printf '\x00\x00\x00\x00\x00\x00' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=27916892 conv=notrunc 2>/dev/null
printf '\x0e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=161937192 conv=notrunc 2>/dev/null
printf '\x07\xc3\xb6\x4a' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=23658816 conv=notrunc 2>/dev/null
printf '\x15\x53\xc9\xe2\xfc\xb0\x53\x07\x6d\x5c\x1b\x44\x2d\x8a\x98\x2c\xcb\x2a\x56\x4f' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=23658820 conv=notrunc 2>/dev/null
printf '\x40\x6c\xcc\xa6' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=154903504 conv=notrunc 2>/dev/null
printf '\x8c\xd1\xb6\xf1\x62\x54\x2c\x8c\xec\x74\x2a\xc8\x09\x3f\x7e\xec\xbd\xfe\x60\x75' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=154903508 conv=notrunc 2>/dev/null
printf '\xb4\x10\x85\x29' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=23658770 conv=notrunc 2>/dev/null
printf '\xb4\x10\x85\x29' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=254868385 conv=notrunc 2>/dev/null
printf '\x38\xab\x15\xc2' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=154903462 conv=notrunc 2>/dev/null
printf '\x38\xab\x15\xc2' | dd of=/data/local/tmp/base_gate.apk bs=1 seek=254869269 conv=notrunc 2>/dev/null
md5sum /data/local/tmp/base_gate.apk
