
$ErrorActionPreference='Continue'
$S='127.0.0.1:5556'
$dir = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$apk = "$dir\m17_base_q_signed.apk"
$total = (Get-Item $apk).Length
$md5 = (Get-FileHash -Algorithm MD5 $apk).Hash.ToLower()
$base = 'https://jazz-hitting-privileges-dans.trycloudflare.com'
Write-Output "TOTAL=$total MD5=$md5"
# speed test with 1MB file
$sw = [System.Diagnostics.Stopwatch]::StartNew()
adb -s $S shell "su -c 'curl -s -L -o /data/local/tmp/spd.bin $base/t1024k.bin'"
$sw.Stop()
Write-Output "SPEEDTEST_1MB_SECONDS=$($sw.Elapsed.TotalSeconds)"
# main download with resume + retries
adb -s $S shell 'rm -f /data/local/tmp/final.apk'
for($t=1;$t -le 15;$t++){
  adb -s $S shell "su -c 'curl -s -L -C - -o /data/local/tmp/final.apk $base/m17_base_q_signed.apk'"
  $sz=((adb -s $S shell 'stat -c %s /data/local/tmp/final.apk') -replace '\D','')
  Write-Output "TRY=$t SIZE=$sz EXPECT=$total"
  if($sz -eq $total){ Write-Output 'DOWNLOAD_OK'; break }
  Start-Sleep -Seconds 3
}
$remoteMd5=((adb -s $S shell 'md5sum /data/local/tmp/final.apk') -split '\s+')[0].Trim()
Write-Output "MD5 remote=$remoteMd5 local=$md5"
if($remoteMd5 -ne $md5){ Write-Output 'MD5_MISMATCH'; exit 1 }
$paths=((adb -s $S shell 'pm path com.dragon.read.oversea.gp') -split '\n') | ForEach-Object { ($_ -replace 'package:','').Trim() } | Where-Object { $_ }
$splits=@($paths | Where-Object { $_ -like '*split_*' })
foreach($p in $splits){ Write-Output "SPLIT_ON_DEVICE=$p" }
$im = adb -s $S shell "pm install-multiple -r /data/local/tmp/final.apk $($splits -join ' ')"
Write-Output "INSTALL1: $($im -join ' ')"
if(($im -join ' ') -notmatch 'Success'){
  $splitSizes = ($splits | ForEach-Object { [int]((adb -s $S shell "stat -c %s $_") -replace '\D','') })
  $sessionSize = $total + ($splitSizes | Measure-Object -Sum).Sum
  $create = (adb -s $S shell "pm install-create -r -S $sessionSize") -join ' '
  Write-Output "CREATE: $create"
  $sid = [regex]::Match($create,'\[(\d+)\]').Groups[1].Value
  adb -s $S shell "pm install-write $sid base.apk /data/local/tmp/final.apk"
  foreach($p in $splits){
    $name = [System.IO.Path]::GetFileName($p)
    adb -s $S shell "pm install-write $sid $name $p"
  }
  $commit = (adb -s $S shell "pm install-commit $sid") -join ' '
  Write-Output "COMMIT: $commit"
}
Write-Output 'INSTALL_DONE'
adb -s $S shell 'rm -f /data/local/tmp/final.apk /data/local/tmp/spd.bin'
adb -s $S shell 'rm -rf /data/local/tmp/ck'
