
$ErrorActionPreference='Continue'
$dir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$apk = "$dir\m17_base_q_signed.apk"
$S = '127.0.0.1:5556'
$chunk = 1MB
function Ensure-Link {
  for($t=0;$t -lt 10;$t++){
    $dev = (adb devices | Select-String "$S\s+device$")
    if($dev){ return $true }
    adb disconnect $S 2>$null | Out-Null
    adb connect $S 2>$null | Out-Null
    Start-Sleep -Seconds 3
  }
  return $false
}
if(-not (Ensure-Link)){ Write-Output 'LINK_DEAD'; exit 1 }
$bytes=[System.IO.File]::ReadAllBytes($apk)
$total=$bytes.Length
$md5=(Get-FileHash -Algorithm MD5 $apk).Hash.ToLower()
Write-Output "TOTAL=$total LOCAL_MD5=$md5"
adb -s $S shell 'rm -rf /data/local/tmp/ck; mkdir -p /data/local/tmp/ck' | Out-Null
$n=[math]::Ceiling($total/$chunk)
for($i=0;$i -lt $n;$i++){
  $start=$i*$chunk; $len=[math]::Min($chunk,$total-$start)
  $part=New-Object byte[] $len
  [Array]::Copy($bytes,$start,$part,0,$len)
  $tmp="$dir\ck_$i.bin"
  [System.IO.File]::WriteAllBytes($tmp,$part)
  $ok=$false
  for($t=1;$t -le 8;$t++){
    if(-not (Ensure-Link)){ Start-Sleep -Seconds 3 }
    adb -s $S push $tmp "/data/local/tmp/ck/c$i.bin" 2>$null | Out-Null
    if($LASTEXITCODE -eq 0){$ok=$true;break}
    Start-Sleep -Seconds 2
  }
  Remove-Item $tmp -Force
  if(-not $ok){ Write-Output "FAIL_CHUNK=$i"; exit 1 }
  if($i % 20 -eq 0){ Write-Output "CHUNK_OK=$i/$n" }
}
Write-Output 'ALL_CHUNKS_PUSHED'
$cat = 'i=0; while [ $i -lt ' + $n + ' ]; do cat /data/local/tmp/ck/c$i.bin; i=$((i+1)); done > /data/local/tmp/final.apk'
adb -s $S shell $cat
$remoteMd5=((adb -s $S shell 'md5sum /data/local/tmp/final.apk') -split '\s+')[0].Trim()
Write-Output "REMOTE_MD5=$remoteMd5 EXPECT=$md5"
if($remoteMd5 -ne $md5){ Write-Output 'MD5_MISMATCH'; exit 1 }
Write-Output 'MD5_OK'
$paths=((adb -s $S shell 'pm path com.dragon.read.oversea.gp') -split '\n') | ForEach-Object { ($_ -replace 'package:','').Trim() } | Where-Object { $_ }
$splits=@($paths | Where-Object { $_ -like '*split_*' })
foreach($p in $splits){ Write-Output "SPLIT_ON_DEVICE=$p" }
# attempt 1: pm install-multiple
$im = adb -s $S shell "pm install-multiple -r /data/local/tmp/final.apk $($splits -join ' ')"
Write-Output "ATTEMPT1: $im"
if(($im -join ' ') -notmatch 'Success'){
  # attempt 2: session with explicit size
  $splitSizes = ($splits | ForEach-Object { [int]((adb -s $S shell "stat -c %s $_") -replace '\D','') })
  $sessionSize = $total + ($splitSizes | Measure-Object -Sum).Sum
  Write-Output "SESSION_SIZE=$sessionSize"
  $create = (adb -s $S shell "pm install-create -r -S $sessionSize") -join ' '
  Write-Output "CREATE: $create"
  $sid = [regex]::Match($create,'\[(\d+)\]').Groups[1].Value
  Write-Output "SID=$sid"
  adb -s $S shell "pm install-write $sid base.apk /data/local/tmp/final.apk"
  $idx=0
  foreach($p in $splits){
    $name = [System.IO.Path]::GetFileName($p)
    adb -s $S shell "pm install-write $sid $name $p"
    $idx++
  }
  $commit = (adb -s $S shell "pm install-commit $sid") -join ' '
  Write-Output "COMMIT: $commit"
}
Write-Output 'INSTALL_DONE'
adb -s $S shell 'rm -rf /data/local/tmp/ck /data/local/tmp/final.apk' | Out-Null
