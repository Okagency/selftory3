[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$imgDir = "D:/dev/selftory3/output/MES구축가이드/images"

function B64 { param($path, $mime); $bytes = [System.IO.File]::ReadAllBytes($path); return "data:$mime;base64," + [Convert]::ToBase64String($bytes) }
function Fig { param($src, $caption); return '<figure><img src="' + $src + '" alt=""><figcaption>' + $caption + '</figcaption></figure>' }

# 주조 사진 9장 (용해로 + CNC 추가)
$cold_die = B64 "$imgDir/cold_chamber_die_casting.svg" "image/svg+xml"
$hot_die = B64 "$imgDir/hot_chamber_die_casting.svg" "image/svg+xml"
$hpdc_4000 = B64 "$imgDir/hpdc_4000t.jpg" "image/jpeg"
$buhler = B64 "$imgDir/buhler_diecasting.jpg" "image/jpeg"
$hpdc_plant = B64 "$imgDir/hpdc_bay_urse.jpg" "image/jpeg"
$engine_bare = B64 "$imgDir/engine_block_bare.jpg" "image/jpeg"
$engine_18xer = B64 "$imgDir/engine_block_18xer.jpg" "image/jpeg"
$induction = B64 "$imgDir/induction_sheffield.jpg" "image/jpeg"
$cnc = B64 "$imgDir/cnc_dynamics.jpg" "image/jpeg"

$casting_section = @"
<section id="ch1-images">
 <h2 class="part">주조 도식·설비·부품 사진
 <small>1·2장 본문 보조 자료 — Wikimedia Commons CC-BY-SA</small>
 </h2>

 <p>주조 핵심 설비·금형·자동차 부품의 시각 자료. 본문 1·2장과 함께 본다.</p>

"@ + (Fig $induction "사진 1.3a — 유도로 (Electric Induction Furnace · Sheffield). 전자기 유도로 알루미늄 합금 700~800도 용해. 자동차 주조 협력사 표준 용해 설비. 코일·도가니·LF·HF (50~200 kHz). (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $cold_die "도식 1.5a — 콜드 챔버 다이캐스팅 머신 스키매틱. 알루미늄 합금 표준. 사출 슬리브에서 플런저가 용탕을 금형 캐비티로 700~1,000 bar 고압 주입. (Wikimedia · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $hot_die "도식 1.5b — 핫 챔버 다이캐스팅 머신 스키매틱. 아연·마그네슘 합금. 융탕이 머신 안 보온로에 직접 들어있음. 가오리 펌프 사출. (Wikimedia · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $hpdc_4000 "사진 1.5c — 4000톤 고압 다이캐스팅(HPDC) 머신. 미션 케이스·엔진 블록 등 대형 구조 부품 양산 설비. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $buhler "사진 1.5d — Bühler 다이캐스팅 머신. 스위스 Bühler는 글로벌 자동차 다이캐스팅 머신 1위. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $hpdc_plant "사진 1.5e — HPDC 공장 라인 (Bay-Urse Plant). 머신·금형·인출 로봇·후공정 일체화. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $cnc "사진 1.7a — CNC 가공 머신 (CNC Dynamics CDS). 주조 후처리 CNC 정밀 가공 — 홀·면·나사·정밀 가공. 머신·툴 보유·자동 측정. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $engine_bare "사진 2.1a — 자동차 엔진 블록 (B8444S Volvo). 알루미늄 합금 HPDC·CNC 가공 후 표면. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $engine_18xer "사진 2.1b — 18XER 엔진 블록. 자동차 엔진 블록의 머시닝 후 표면 디테일. (Wikimedia · CC-BY-SA)") + @"

</section>

"@

$casting_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($casting_file, [System.Text.Encoding]::UTF8)
$pattern = '(?s)<section id="ch1-images">.*?</section>\s*'
$content = $content -replace $pattern, $casting_section
[System.IO.File]::WriteAllText($casting_file, $content, $utf8NoBom)
Write-Host "casting images updated with induction furnace + CNC"
