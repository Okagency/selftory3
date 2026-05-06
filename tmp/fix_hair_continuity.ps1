[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# 단발컷 발생 위치 (방금 삽입한 자리)
$cutMarker = '<p>서책임이 단발이었다.</p>'
$cutIdx = $c.IndexOf($cutMarker)
if ($cutIdx -lt 0) { Write-Host "단발컷 marker 못 찾음"; exit 1 }
Write-Host "단발컷 위치: $cutIdx"

# 컷 이전 영역
$before = $c.Substring(0, $cutIdx)
$after = $c.Substring($cutIdx)

$beforeLenBefore = $before.Length

# 단발 표현 → 묶은 긴 머리 표현으로 변경 (컷 이전만)
# 다양한 단발 표현 패턴
$before = $before -replace '평소 단정한 단발', '평소 단정하게 묶은 긴 머리'
$before = $before -replace '단정한 단발', '단정하게 묶은 머리'
$before = $before -replace '한쪽으로 살짝 흘러내려', '몇 가닥이 살짝 흘러내려'
$before = $before -replace '단발이 한쪽으로 흘러내려', '묶은 머리가 한 자락 흘러내려'
$before = $before -replace '단발이 살짝 풀어 내린', '묶은 머리가 살짝 풀어 내린'
$before = $before -replace '단발 끝이 셔츠 칼라', '머리끝이 셔츠 칼라'
$before = $before -replace '그녀의 단발', '그녀의 묶은 머리'
$before = $before -replace '평소 단발', '평소 묶은 머리'
$before = $before -replace '단발이 한 자락', '머리 한 자락이'
$before = $before -replace '단발이 흐트러졌다', '묶은 머리가 흐트러졌다'
$before = $before -replace '단발', '머리'

$beforeLenAfter = $before.Length

# 결합
$result = $before + $after
$result | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "컷 이전 영역: $beforeLenBefore -> $beforeLenAfter (변화 $($beforeLenAfter - $beforeLenBefore)자)"
Write-Host ""
Write-Host "컷 이전 영역 단발 잔여: $(([regex]::Matches($before, '단발')).Count)"
Write-Host "컷 이후 영역 단발: $(([regex]::Matches($after, '단발')).Count)"
