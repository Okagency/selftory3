[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 사진 시퀀스 전체 — 처음부터 끝까지 (중복 prefix + 모든 묘사) → 6줄로
# 시작: " <hr class=\"scene\"> <p>그리고 — 그로부터 약 두 달이 지난 어느 금요일 새벽 1시 42분.</p>"
# 끝: "한 자락의 선만은 12년차의 무게로 지켜졌다.</p>"

$startMarker = '<hr class="scene"> <p>그리고 — 그로부터 약 두 달이 지난 어느 금요일 새벽 1시 42분.</p>'
$endMarker = '한 자락의 선만은 12년차의 무게로 지켜졌다.</p>'

$startIdx = $c.IndexOf($startMarker)
$endIdx = $c.IndexOf($endMarker)

if ($startIdx -lt 0) { Write-Host "시작 marker 못 찾음"; exit 1 }
if ($endIdx -lt 0) { Write-Host "끝 marker 못 찾음"; exit 1 }

$endIdx = $endIdx + $endMarker.Length
$beforeArea = $endIdx - $startIdx
Write-Host "기존 영역: $beforeArea 자"

$newContent = @"
<hr class="scene"> <p id="scene-photo-mistake">그로부터 두 달 뒤. 카톡 한 장.</p>

 <p><strong>사진.</strong></p>

 <p>다음 날.</p>

 <p>"재훈씨 — 어젯밤 사진, 지워주세요."</p>
"@

$result = $c.Substring(0, $startIdx) + $newContent + " " + $c.Substring($endIdx)
$result | Set-Content $f -Encoding UTF8 -NoNewline

$afterLen = $result.Length
Write-Host "변화: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
