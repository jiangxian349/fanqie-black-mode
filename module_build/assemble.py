
import zipfile, sys
base, dex, init, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
zout = zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED, compresslevel=6)
import io
zin = zipfile.ZipFile(base)
for item in zin.infolist():
    data = zin.read(item.filename)
    zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
    zi.compress_type = item.compress_type
    zi.external_attr = item.external_attr
    zout.writestr(zi, data)
for name, path in [('classes.dex', dex), ('assets/xposed_init', init)]:
    with open(path, 'rb') as f:
        zout.writestr(name, f.read())
zout.close()
print('assembled', out)
