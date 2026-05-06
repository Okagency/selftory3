[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$nf = 'D:\dev\selftory\tmp\new_sihwa.txt'

$c = Get-Content $f -Raw -Encoding UTF8
$new_sihwa = Get-Content $nf -Raw -Encoding UTF8

$beforeLen = $c.Length

# === 1) 시화 횟집 회식 시퀀스 교체 ===
# 시작 marker: <hr class="scene"> + "<p>그날 저녁 회식은 시화의 한 횟집이었다."
# 끝 marker: "우리는 다른 방향으로 갔다.</p>" 직후, scene-katok-217 직전

$startMarker1 = '<p>그날 저녁 회식은 시화의 한 횟집이었다'
$startIdx1 = $c.IndexOf($startMarker1)
if ($startIdx1 -lt 0) { Write-Host "시화 시작 marker 못 찾음"; exit 1 }
# 그 앞 <hr class="scene">까지 포함
$hr1 = $c.LastIndexOf('<hr class="scene">', $startIdx1)
if ($hr1 -lt 0) { $hr1 = $startIdx1 }

$endMarker1 = '<p id="scene-katok-217">'
$endIdx1 = $c.IndexOf($endMarker1, $startIdx1)
if ($endIdx1 -lt 0) { Write-Host "scene-katok-217 marker 못 찾음"; exit 1 }

$beforeArea1 = $endIdx1 - $hr1
Write-Host "1단계: 시화 횟집 영역 길이: $beforeArea1 자"

$c1 = $c.Substring(0, $hr1) + $new_sihwa + " " + $c.Substring($endIdx1)

Write-Host "1단계 완료. 신규 콘텐츠 $($new_sihwa.Length)자"

# === 2) 사진 실수 시퀀스 추출 (26장에서 잘라내기) ===
# scene-photo-mistake 시작 ~ 그 직후 hr.scene까지

$photoStart = '<p id="scene-photo-mistake">'
$photoIdx = $c1.IndexOf($photoStart)
if ($photoIdx -lt 0) { Write-Host "scene-photo-mistake marker 못 찾음"; exit 1 }

# 사진 실수 시퀀스 끝 — "두 사람만 아는 침묵이 한 톤으로 회의실 형광등 아래에서..." 단락 끝
# 또는 다음 hr.scene 또는 다른 anchor
$photoEndPattern = '밀고 당기는 그 미세한 거리가 18개월 동안'
$photoEndIdx = $c1.IndexOf($photoEndPattern, $photoIdx)
if ($photoEndIdx -lt 0) {
    Write-Host "사진 실수 끝 marker 못 찾음 — 대안 검색"
    $photoEndPattern = '<hr class="scene">'
    $photoEndIdx = $c1.IndexOf($photoEndPattern, $photoIdx + 100)
}
# 그 앞 <p> 시작점
$photoEndPStart = $c1.LastIndexOf('<p>', $photoEndIdx)
if ($photoEndPStart -lt 0) { $photoEndPStart = $photoEndIdx }

# 사진 실수 시퀀스 텍스트 추출
$photoContent = $c1.Substring($photoIdx, $photoEndPStart - $photoIdx)
Write-Host "2단계: 사진 실수 시퀀스 길이: $($photoContent.Length)자"

# 26장에서 사진 실수 + 그 앞 hr.scene 삭제
$photoHr = $c1.LastIndexOf('<hr class="scene">', $photoIdx)
if ($photoHr -lt 0 -or $photoHr -lt $photoIdx - 200) { $photoHr = $photoIdx }
$c2 = $c1.Substring(0, $photoHr) + $c1.Substring($photoEndPStart)

Write-Host "2단계: 26장에서 사진 실수 시퀀스 제거"

# === 3) 사진 실수 시퀀스를 31장 끝(머리 자른 시퀀스 직후)에 삽입 ===
# 31장의 "베트남 출장에서 돌아온 후 어느 새벽 서책임이 머리를 잘랐다" 단락이 사라졌으니
# 다른 위치 — 31장 keypoint 직전 또는 scene-perm-04 직후
# 가장 자연스러운 자리: scene-perm-04(UAT 둘째 주 펌 0.4초) 단락 직후

# 그러나 31장 시퀀스가 새 베트남 출장으로 재구성됐으니 — scene-perm-04도 사라졌을 수 있음
# 안전하게: 31장 핵심 keypoint 직전에 삽입

$insertMarker = ' <div class="keypoint-title">31장 핵심</div>'
$insertIdx = $c2.IndexOf($insertMarker)
if ($insertIdx -lt 0) { Write-Host "31장 핵심 keypoint 못 찾음"; exit 1 }
# 그 앞 <hr class="scene">
$insertHr = $c2.LastIndexOf('<hr class="scene">', $insertIdx)

# 사진 실수 시퀀스를 시간 갭 명시와 함께 삽입
$photoNew = "`r`n <hr class=`"scene`"> <p>그리고 — 그로부터 약 두 달이 지난 어느 금요일 새벽 1시 42분.</p>`r`n" + $photoContent

$c3 = $c2.Substring(0, $insertHr) + $photoNew + " " + $c2.Substring($insertHr)

Write-Host "3단계: 사진 실수 시퀀스를 31장 UAT 끝에 삽입"

# === 4) 색인·썸 리스트의 사진 실수 anchor 위치 변경 ===
$c3 = $c3 -replace '<a href="#scene-photo-mistake">26장 끝 직후</a>', '<a href="#scene-photo-mistake">31장 후반</a>'
$c3 = $c3 -replace '<a href="#scene-photo-mistake">26장 끝 직후 — 두 달 후', '<a href="#scene-photo-mistake">31장 후반 — 두 달 후'

$afterLen = $c3.Length
$c3 | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "총 변화: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host "scene-photo-mistake 위치 확인:"
$verifyIdx = $c3.IndexOf('<p id="scene-photo-mistake">')
Write-Host "  본문 위치: $verifyIdx"
