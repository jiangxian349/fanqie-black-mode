
import zipfile, re, sys
src, dst = sys.argv[1], sys.argv[2]
P1 = bytes([0x08,0,0,0x1c, 0x0e,0x0e,0x0e,0xff]); P2 = bytes([0x08,0,0,0x1d, 0x0e,0x0e,0x0e,0xff])
R1 = bytes([0x08,0,0,0x1c, 0,0,0,0xff]); R2 = bytes([0x08,0,0,0x1d, 0,0,0,0xff])
zin = zipfile.ZipFile(src); zout = zipfile.ZipFile(dst,'w',zipfile.ZIP_DEFLATED,compresslevel=1)
stats={}
for item in zin.infolist():
    data = zin.read(item.filename)
    if item.filename.endswith('resources.arsc'):
        c = data.count(P1)+data.count(P2)
        if c:
            data = data.replace(P1,R1).replace(P2,R2)
            stats['arsc_colors'] = c
    zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
    zi.compress_type = item.compress_type; zi.external_attr = item.external_attr; zi.create_system = item.create_system
    zout.writestr(zi, data)
zout.close()
print('ARSC_ONLY_PATCH', stats)
