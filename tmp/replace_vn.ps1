[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$nf = 'D:\dev\selftory\tmp\new_vn_full.txt'

$c = Get-Content $f -Raw -Encoding UTF8
$new = Get-Content $nf -Raw -Encoding UTF8

# 시작·끝 marker
# 시작: scene-rain-twin (UAT 빗속 호텔 트윈룸) 끝난 직후, "이튿날 아침 9시 회의 시작 직전" 운영위 메일 단락부터
$startMarker = '이튿날 아침 9시 회의 시작 직전. 서책임이 평소 톤으로 운영위 메일'
$startIdx = $c.IndexOf($startMarker)

# 끝: 31장 핵심 keypoint 직전 — 그 앞 hr.scene + div class="keypoint" 까지 잘라냄
# 31장 핵심 keypoint-title 위치 기준으로 그 앞 <hr class="scene"> 위치 찾기
$kpIdx = $c.IndexOf('keypoint-title">31장 핵심')
if ($kpIdx -lt 0) { Write-Host "keypoint-title 못 찾음"; exit 1 }
# 그 앞 <hr class="scene"> 위치
$endIdx = $c.LastIndexOf('<hr class="scene">', $kpIdx)
Write-Host "endIdx (hr scene): $endIdx, kpIdx: $kpIdx"

if ($startIdx -lt 0) { Write-Host "시작 marker 못 찾음"; exit 1 }
if ($endIdx -lt 0) { Write-Host "끝 marker 못 찾음"; exit 1 }

# 시작 marker가 들어있는 <p> 시작점 찾기 (그 앞 <p> 태그부터)
$pStart = $c.LastIndexOf('<p>', $startIdx)
if ($pStart -lt 0) { $pStart = $startIdx }

$beforeLen = $endIdx - $pStart
Write-Host "교체 영역 길이: $beforeLen 자"

# 교체
$before = $c.Substring(0, $pStart)
$after = $c.Substring($endIdx)
$result = $before + $new + " " + $after

$result | Set-Content $f -Encoding UTF8 -NoNewline

$newLen = $new.Length
Write-Host "신규 콘텐츠 길이: $newLen 자"
Write-Host "변화: $beforeLen -> $newLen (감소 $($beforeLen - $newLen)자)"
