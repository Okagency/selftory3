[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '신입')).Count

# 윤지수 가리키는 "신입" → "윤지수" 변환 (자리별)
$c = $c -replace '신입 옆 자리', '윤지수 옆 자리'
$c = $c -replace '신입 옆자리', '윤지수 옆자리'
$c = $c -replace '신입 옆에', '윤지수 옆에'
$c = $c -replace '신입의 명함', '윤지수의 명함'
$c = $c -replace '신입은 빠르게', '윤지수는 빠르게'
$c = $c -replace '신입의 첫', '윤지수의 첫'
$c = $c -replace '신입에게는', '윤지수에게는'
$c = $c -replace '신입에게', '윤지수에게'
$c = $c -replace '신입의 펜', '윤지수의 펜'
$c = $c -replace '신입이 한 번', '윤지수가 한 번'
$c = $c -replace '신입이 그날', '윤지수가 그날'
$c = $c -replace '신입이 평소', '윤지수가 평소'
$c = $c -replace '신입이 자기', '윤지수가 자기'
$c = $c -replace '신입이 잠깐', '윤지수가 잠깐'
$c = $c -replace '신입이 결함', '윤지수가 결함'
$c = $c -replace '신입이 들고', '윤지수가 들고'
$c = $c -replace '신입이 한 마디', '윤지수가 한 마디'
$c = $c -replace '신입이 ', '윤지수가 '
$c = $c -replace '신입은 ', '윤지수는 '
$c = $c -replace '신입의 ', '윤지수의 '
$c = $c -replace '신입을 ', '윤지수를 '
$c = $c -replace '신입과', '윤지수와'
$c = $c -replace '신입도', '윤지수도'
$c = $c -replace '신입이라', '윤지수라'

# 일반 명사 "신입 양성", "신입 합류", "신입 교육" 등은 그대로 유지를 위해 — 위 패턴이 그것들과 충돌 안 됨

# "윤지수씨" 보호 후 "윤지수" → "지수"
$c = $c -replace '윤지수씨', '@@PROTECT_YJS@@'
$c = $c -replace '윤지수', '지수'
$c = $c -replace '@@PROTECT_YJS@@', '윤지수씨'

$after = ([regex]::Matches($c, '신입')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "신입 출현: $before -> $after"
