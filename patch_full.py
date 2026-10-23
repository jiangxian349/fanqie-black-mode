
import zipfile, re, sys
def patch(src, dst):
    P1 = bytes([0x08,0,0,0x1c, 0x0e,0x0e,0x0e,0xff]); P2 = bytes([0x08,0,0,0x1d, 0x0e,0x0e,0x0e,0xff])
    R1 = bytes([0x08,0,0,0x1c, 0,0,0,0xff]); R2 = bytes([0x08,0,0,0x1d, 0,0,0,0xff])
    TAIL = bytes([0x00,0x00,0x00,0xff])
    rx18 = re.compile(b'\x18([\x00-\xff])\x0e\x0e\x0e\xff')
    rx14 = re.compile(b'\x14([\x00-\xff])\x0e\x0e\x0e\xff')
    zin = zipfile.ZipFile(src); zout = zipfile.ZipFile(dst,'w',zipfile.ZIP_DEFLATED,compresslevel=1)
    stats={}
    for item in zin.infolist():
        data = zin.read(item.filename)
        if item.filename.endswith('resources.arsc'):
            c = data.count(P1)+data.count(P2)
            if c: data = data.replace(P1,R1).replace(P2,R2); stats[item.filename]=c
        elif re.match(r'classes\d*\.dex$', item.filename):
            c1 = len(rx18.findall(data)); c2 = len(rx14.findall(data))
            if c1 or c2:
                data = rx18.sub(lambda m: b'\x18' + m.group(1) + TAIL, data)
                data = rx14.sub(lambda m: b'\x14' + m.group(1) + TAIL, data)
                stats[item.filename]=[c1,c2]
        zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
        zi.compress_type = item.compress_type; zi.external_attr = item.external_attr; zi.create_system = item.create_system
        zout.writestr(zi, data)
    zout.close()
    z = zipfile.ZipFile(dst)
    rem = {}
    for n in z.namelist():
        if n.endswith('resources.arsc') or re.match(r'classes\d*\.dex$', n):
            k = z.read(n).count(bytes([0x0e,0x0e,0x0e,0xff]))
            if k: rem[n]=k
    print('STATS', dst.split(chr(92))[-1], stats, '| remaining:', rem, flush=True)
for i in range(1, len(sys.argv), 2):
    patch(sys.argv[i], sys.argv[i+1])
print('ALL_PATCHED')
