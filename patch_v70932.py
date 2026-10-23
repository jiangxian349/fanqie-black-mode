
import zipfile, sys
src = r'.\fanqie_base.apk'
dst = r'.\fanqie_patched_raw.apk'
P1 = bytes([0x08,0,0,0x1c, 0x0e,0x0e,0x0e,0xff])   # Res_value ARGB8 #FF0E0E0E
P2 = bytes([0x08,0,0,0x1d, 0x0e,0x0e,0x0e,0xff])   # Res_value RGB8  #FF0E0E0E
R1 = bytes([0x08,0,0,0x1c, 0x00,0x00,0x00,0xff])
R2 = bytes([0x08,0,0,0x1d, 0x00,0x00,0x00,0xff])
DEXP = bytes([0x0e,0x0e,0x0e,0xff]); DEXR = bytes([0x00,0x00,0x00,0xff])
DEXSET = {'classes4.dex','classes6.dex','classes24.dex'}
zin = zipfile.ZipFile(src)
zout = zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED, compresslevel=6)
stats = {}
for item in zin.infolist():
    data = zin.read(item.filename)
    if item.filename == 'resources.arsc':
        c1, c2 = data.count(P1), data.count(P2)
        data = data.replace(P1, R1).replace(P2, R2)
        stats['resources.arsc'] = {'argb8': c1, 'rgb8': c2}
    elif item.filename in DEXSET:
        c = data.count(DEXP)
        data = data.replace(DEXP, DEXR)
        stats[item.filename] = c
    zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
    zi.compress_type = item.compress_type
    zi.external_attr = item.external_attr
    zi.create_system = item.create_system
    zout.writestr(zi, data)
zout.close(); zin.close()
# verify
z = zipfile.ZipFile(dst)
a = z.read('resources.arsc')
dv = {n: z.read(n).count(DEXP) for n in DEXSET}
print('PATCH_STATS', stats)
print('VERIFY remaining FF0E0E0E in arsc:', a.count(bytes([0x0e,0x0e,0x0e,0xff])), 'in dex:', dv)
print('VERIFY new FF000000 headers in arsc:', a.count(R1) + a.count(R2))
