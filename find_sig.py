
import zipfile, sys
src = sys.argv[1]
def clean(s): return ''.join(c for c in s if c in '0123456789abcdefABCDEF')
SHA1C  = 'AB:6D:13:58:22:5F:F7:AB:C3:A4:42:21:A6:A0:C7:AD:44:A0:AA:4B'
SHA256C = '61:56:D2:CC:0A:25:5D:68:74:9E:8B:68:63:CF:2F:D9:A0:0F:6A:5A:39:13:7E:74:62:DA:EB:5B:4B:61:14:90'
SER  = 'd00e57f6e4fac7f26de7d1aa3c100e6c3aab6537'
s1 = clean(SHA1C); s2 = clean(SHA256C); sr = clean(SER)
assert len(s1) == 40 and len(s2) == 64 and len(sr) in (36, 40), (len(s1), len(s2), len(sr))
patterns = {
 'sha1_bytes': bytes.fromhex(s1),
 'sha256_bytes': bytes.fromhex(s2),
 'serial_bytes': bytes.fromhex(sr),
 'sha1_hex_lower': s1.lower().encode(),
 'sha1_hex_upper': s1.upper().encode(),
 'sha256_hex_lower': s2.lower().encode(),
 'sha256_hex_upper': s2.upper().encode(),
 'sha1_colon_upper': SHA1C.encode(),
 'sha1_colon_lower': SHA1C.lower().encode(),
 'sha256_colon_upper': SHA256C.encode(),
}
z = zipfile.ZipFile(src)
found = []
for item in z.infolist():
    try: data = z.read(item.filename)
    except Exception: continue
    for name, pat in patterns.items():
        idx = 0; cnt = 0; offs = []
        while True:
            i = data.find(pat, idx)
            if i < 0: break
            cnt += 1; offs.append(i); idx = i + 1
        if cnt: found.append((item.filename, name, cnt, offs[:5]))
for f in found: print('FOUND', f)
if not found: print('NO_MATCHES_IN', src.split(chr(92))[-1])
