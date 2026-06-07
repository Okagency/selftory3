[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$imgDir = "D:/dev/selftory3/output/MES구축가이드/images"

function B64 {
 param($path, $mime)
 if (-not (Test-Path $path)) { Write-Host "missing: $path"; return $null }
 $bytes = [System.IO.File]::ReadAllBytes($path)
 return "data:$mime;base64," + [Convert]::ToBase64String($bytes)
}

function Fig {
 param($src, $caption)
 if ($src -eq $null) { return "" }
 return '<figure><img src="' + $src + '" alt=""><figcaption>' + $caption + '</figcaption></figure>'
}

# ===========================================
# 주조편 사진
# ===========================================
$induction = B64 "$imgDir/induction_furnace.jpg" "image/jpeg"
$hpdc = B64 "$imgDir/hpdc_4000t.jpg" "image/jpeg"
$cold_die = B64 "$imgDir/cold_chamber_die_casting.svg" "image/svg+xml"
$hot_die = B64 "$imgDir/hot_chamber_die_casting.svg" "image/svg+xml"
$engine_block = B64 "$imgDir/engine_block.jpg" "image/jpeg"
$alloy_wheel = B64 "$imgDir/alloy_wheel.jpg" "image/jpeg"
$cylinder_head = B64 "$imgDir/cylinder_head.jpg" "image/jpeg"

$casting_section = @"
<section id="ch1-images">
 <h2 class="part">주조 도식·사진 모음
 <small>1·2장 보조 자료 — Wikimedia Commons CC-BY-SA</small>
 </h2>

 <p>주조 도메인 핵심 설비·공정·자동차 부품 시각 자료. 본문 1·2장과 함께 참조한다.</p>

"@ + (Fig $induction "도식 1.3a — 유도로 (Induction Furnace) — 전자기 유도로 알루미늄 합금을 700~800℃로 용해. 자동차 부품 협력사의 표준 용해 설비. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $hpdc "도식 1.3b — 4000톤 고압 다이캐스팅(HPDC) 머신 — 미션 케이스·엔진 블록 등 대형 구조 부품의 양산 설비. 사출 압력 700~1,000 bar. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $cold_die "도식 1.5a — 콜드 챔버 다이캐스팅 머신 스키매틱 — 알루미늄 합금 다이캐스팅 표준 구조. 슬리브에서 사출 플런저가 용탕을 금형 캐비티로 고압 주입. (Wikimedia Commons · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $hot_die "도식 1.5b — 핫 챔버 다이캐스팅 머신 스키매틱 — 아연·마그네슘 합금에 주로 사용. 융탕이 머신 안 보온로에 직접 들어있음. (Wikimedia Commons · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $engine_block "도식 2.1a — 자동차 엔진 블록 — 사형주조·HPDC로 만들어지는 자동차 가장 큰 주조 부품 중 하나. 알루미늄 A356·319 합금. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $alloy_wheel "도식 2.1b — 알루미늄 알로이 휠 — 저압 다이캐스팅(LPDC) 표준 부품. A356 합금·T6 열처리. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $cylinder_head "도식 2.1c — 실린더 헤드 — 저압 다이캐스팅·중력 다이캐스팅으로 양산. A356·A357 합금. (Wikimedia Commons · CC-BY-SA)") + @"

</section>

"@

$casting_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($casting_file, [System.Text.Encoding]::UTF8)
$marker = '<section id="ch2-wrap">'
if ($content.IndexOf($marker) -lt 0) { Write-Host "casting marker not found"; exit 1 }
$newContent = $content.Replace($marker, $casting_section + $marker)
[System.IO.File]::WriteAllText($casting_file, $newContent, $utf8NoBom)
Write-Host "casting images embedded"

# ===========================================
# 사출편 사진
# ===========================================
$spritzguss = B64 "$imgDir/spritzguss.jpg" "image/jpeg"
$plastic_moulding = B64 "$imgDir/plastic_moulding.jpg" "image/jpeg"
$el_exis = B64 "$imgDir/el_exis_sp300.jpg" "image/jpeg"
$car_bumper = B64 "$imgDir/car_bumper.jpg" "image/jpeg"
$injection_mold = B64 "$imgDir/injection_mold.jpg" "image/jpeg"
$injected_parts = B64 "$imgDir/injected_parts.jpg" "image/jpeg"
$pellets = B64 "$imgDir/pellets.jpg" "image/jpeg"
$industrial_robot = B64 "$imgDir/industrial_robot.jpg" "image/jpeg"

$injection_section = @"
<section id="ch1-images">
 <h2 class="part">사출 도식·사진 모음
 <small>1·2장 보조 자료 — Wikimedia Commons CC-BY-SA</small>
 </h2>

 <p>사출 도메인 핵심 설비·금형·자동차 부품·자재 시각 자료. 본문 1·2장과 함께 참조한다.</p>

"@ + (Fig $el_exis "도식 1.2a — Sumitomo Demag El-Exis SP 300 사출기 — 정밀·반복성·전동식 사출기. 자동차 광학·전장 부품 양산. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $spritzguss "도식 1.2b — 사출 성형 라인 (Spritzgießanlage) — 사출기·금형·로봇 인출의 일체화 라인. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $plastic_moulding "도식 1.2c — 플라스틱 사출 머신 — 수평형 사출기 표준 구성. 호퍼·스크류·사출 노즐·금형. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $injection_mold "도식 1.5a — 사출 금형 — 1금형 4~32 캐비티 동시 성형. 캐비티별 분리 추적이 사출 MES의 핵심. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $industrial_robot "도식 1.5b — 산업용 로봇 (인출용) — Euromap 67 표준으로 사출기와 통신. 캐비티별 인출·이송. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $pellets "도식 1.4a — 플라스틱 펠릿 (Resin Pellets) — 사출 신원료. PP·ABS·PC·PA·PBT 등 도메인별 등급. Regrind는 이 펠릿에 일정 비율 혼합. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $car_bumper "도식 2.1a — 자동차 범퍼 — PP/EPDM·TPO로 사출. 차량 외장 가장 큰 사출 부품. (Wikimedia Commons · CC-BY-SA)") + "`r`n" + `
(Fig $injected_parts "도식 2.1b — 사출 플라스틱 부품 — 차량 내 수백 개 사출 부품 사례. (Wikimedia Commons · CC-BY-SA)") + @"

</section>

"@

$injection_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($injection_file, [System.Text.Encoding]::UTF8)
$marker = '<section id="ch2-wrap">'
if ($content.IndexOf($marker) -lt 0) { Write-Host "injection marker not found"; exit 1 }
$newContent = $content.Replace($marker, $injection_section + $marker)
[System.IO.File]::WriteAllText($injection_file, $newContent, $utf8NoBom)
Write-Host "injection images embedded"

Write-Host "All done"
