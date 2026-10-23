#!/system/bin/sh
cp $(pm path com.dragon.read.oversea.gp | head -1 | sed 's/package://') /data/local/tmp/base_restore.apk
chmod 644 /data/local/tmp/base_restore.apk
printf '\x6e\x10\xeb\x19\x00\x00' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=27916892 conv=notrunc 2>/dev/null
printf '\x14\x00\x44\x0f\x11\x7f\x12\x11\x71\x20\x14\xa2\x10\x00\x0e\x00' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=161937192 conv=notrunc 2>/dev/null
printf '\x9f\xc2\x2f\x66\x32\x1a\xbb\xfc\xc2\xe8\x0c\xff\x29\xe4\x92\x9f\xe2\x85\x14\xb4\x52\x64\xe2\x16\xcc\xb5\x81\x00\x70\x00\x00\x00' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=23658816 conv=notrunc 2>/dev/null
printf '\x51\xd8\x51\x46\x3c\x1a\x5d\xdd\x93\x20\x5e\x54\x38\xe1\x1c\x01\x4c\xc0\x63\xcd\xe5\xa9\xf5\x50\x44\x97\xa3\x00\x70\x00\x00\x00' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=154903504 conv=notrunc 2>/dev/null
printf '\xc1\xbd\xd5\x2d' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=23658770 conv=notrunc 2>/dev/null
printf '\xc1\xbd\xd5\x2d' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=254868385 conv=notrunc 2>/dev/null
printf '\x8a\xe3\xf9\x13' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=154903462 conv=notrunc 2>/dev/null
printf '\x8a\xe3\xf9\x13' | dd of=/data/local/tmp/base_restore.apk bs=1 seek=254869269 conv=notrunc 2>/dev/null
md5sum /data/local/tmp/base_restore.apk
