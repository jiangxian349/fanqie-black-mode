#!/system/bin/sh
cp $(pm path com.dragon.read.oversea.gp | head -1 | sed 's/package://') /data/local/tmp/base_fix.apk
chmod 644 /data/local/tmp/base_fix.apk
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186201424 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186201898 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186204458 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186205082 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186205194 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186206798 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186212190 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186213286 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=186226794 conv=notrunc 2>/dev/null
printf '\x41\x90\xeb\x5b' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=175451986 conv=notrunc 2>/dev/null
printf '\x41\x90\xeb\x5b' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=254869385 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=207418674 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=207418778 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=207480392 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=207480586 conv=notrunc 2>/dev/null
printf '\xfc\xb5\xaf\xfe' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=197954058 conv=notrunc 2>/dev/null
printf '\xfc\xb5\xaf\xfe' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=254869501 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=131318362 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=131322030 conv=notrunc 2>/dev/null
printf '\x0e\x0e\x0e' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=131325674 conv=notrunc 2>/dev/null
printf '\x3f\xfb\x6b\x94' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=124254834 conv=notrunc 2>/dev/null
printf '\x3f\xfb\x6b\x94' | dd of=/data/local/tmp/base_fix.apk bs=1 seek=254869092 conv=notrunc 2>/dev/null
md5sum /data/local/tmp/base_fix.apk
