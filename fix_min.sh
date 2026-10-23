#!/system/bin/sh
cp $(pm path com.dragon.read.oversea.gp | head -1 | sed 's/package://') /data/local/tmp/base_min.apk
chmod 644 /data/local/tmp/base_min.apk
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250583772 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250597356 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250601084 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250601212 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250601324 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250609132 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250624028 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250626108 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250627580 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250627836 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250627900 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250629164 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250629196 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250629676 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250632508 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250634156 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250634604 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250634636 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250638092 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e\xff' | dd of=/data/local/tmp/base_min.apk bs=1 seek=250667384 conv=notrunc 2>/dev/null
printf '\xf2\xa0\xbc\xb5' | dd of=/data/local/tmp/base_min.apk bs=1 seek=247362554 conv=notrunc 2>/dev/null
printf '\xf2\xa0\xbc\xb5' | dd of=/data/local/tmp/base_min.apk bs=1 seek=256863466 conv=notrunc 2>/dev/null
md5sum /data/local/tmp/base_min.apk
