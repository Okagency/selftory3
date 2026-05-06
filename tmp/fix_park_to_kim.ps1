[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# 박서연 시퀀스 안의 박 사장 → 김 사장 (4단계 스크립트의 결정의 자리)
$c = $c -replace '결정의 자리는 사장님·박 사장님·운영위', '결정의 자리는 김 사장님·운영위'

# 회의 후 박 부장 대사
$c = $c -replace '"박 사장 처조카라고 말씀드렸잖아요\."', '"김 사장 처조카라고 말씀드렸잖아요."'

# 운영위에서 마이크 발언 — 이미 김 사장이 받은 자리이므로 마이크 발언자도 김 사장
$c = $c -replace '박 사장이 마이크에 가까이 다가갔다\.', '김 사장이 마이크에 가까이 다가갔다.'

# 석 달 후 회수 단락 (박 사장 → 김 사장 두 곳)
$c = $c -replace '박 사장이 그 퇴직에 한 마디도 안 보탰다\. 처조카였으나 — 회의실에서의 그 한 마디가 정확했다는 것을, 박 사장도 그날 자리에서 들은 사람이었다\.', '김 사장이 그 퇴직에 한 마디도 안 보탰다. 처조카였으나 — 회의실에서의 그 한 마디가 정확했다는 것을, 김 사장도 그날 자리에서 들은 사람이었다.'

$cnt_park = ([regex]::Matches($c, '박 사장')).Count
$cnt_kim = ([regex]::Matches($c, '김 사장')).Count

$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "박 사장 잔여: $cnt_park"
Write-Host "김 사장 출현: $cnt_kim"
