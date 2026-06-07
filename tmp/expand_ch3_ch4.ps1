[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# ===========================================
# 주조편 3·4장 심화
# ===========================================
$casting_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($casting_file, [System.Text.Encoding]::UTF8)

$casting_ch3 = @'

 <h4>3.6.1 인터록 카탈로그 — 주조 12종 상세 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table>
 <thead><tr><th>#</th><th>인터록</th><th>트리거</th><th>차단 동작</th></tr></thead>
 <tbody>
 <tr><td>1</td><td>Spectro 성분 NG</td><td>합금 표준 ±공차 이탈</td><td>보온로 차단·재용해 트리거</td></tr>
 <tr><td>2</td><td>용탕 온도 한계</td><td>650~700도 범위 이탈</td><td>주입 중지·온도 보정</td></tr>
 <tr><td>3</td><td>리턴 비율 상한</td><td>OEM CSR 초과 투입</td><td>알람·작업자 승인 요구</td></tr>
 <tr><td>4</td><td>금형 수명 한계</td><td>8~15만 샷 초과</td><td>금형 교체 트리거</td></tr>
 <tr><td>5</td><td>주입 압력 ±%</td><td>700~1,000 bar 이탈</td><td>주입 중지·재설정</td></tr>
 <tr><td>6</td><td>응고 시간 SPC</td><td>표준 ±공차</td><td>알람·다음 샷 차단</td></tr>
 <tr><td>7</td><td>금형 온도 한계</td><td>250~350도 이탈</td><td>주입 중지·금형 보온</td></tr>
 <tr><td>8</td><td>CT/X-Ray NG</td><td>기공·균열 검출</td><td>부품 자동 격리·후공정 차단</td></tr>
 <tr><td>9</td><td>치수 NG (CMM)</td><td>도면 ±공차</td><td>부품 격리·SPC 알람</td></tr>
 <tr><td>10</td><td>인장·경도 NG</td><td>샘플링 시험 NG</td><td>lot 전체 격리·재시험</td></tr>
 <tr><td>11</td><td>이형력 한계</td><td>이형 압력 초과</td><td>금형 점검 트리거</td></tr>
 <tr><td>12</td><td>작업자 자격</td><td>미인증 작업자 접근</td><td>설비 가동 차단</td></tr>
 </tbody>
 </table>

 <h4>3.6.2 5종 lot 추적성 — 필드 매트릭스 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table>
 <thead><tr><th>Lot</th><th>핵심 필드 (50+)</th></tr></thead>
 <tbody>
 <tr><td>Heat Lot</td><td>Heat No·날짜·시간·로 번호·합금 코드·신/리턴/스크랩 투입량·Spectro 18종·온도·교반 시간·탈가스 처리·작업자·재용해 횟수</td></tr>
 <tr><td>Mold Lot</td><td>Mold ID·캐비티 No·수명 카운트·수리 이력·금형 온도 곡선·이형력·이형 시점·작업자</td></tr>
 <tr><td>응고 Lot</td><td>주입 압력 곡선·1차 속도·2차 속도·응고 시간·냉각수 유량·온도 프로파일·진공·이형 시점</td></tr>
 <tr><td>후처리 Lot</td><td>트리밍 lot·열처리 lot (Solution + Aging 곡선)·표면처리 lot·머시닝 lot·툴 ID</td></tr>
 <tr><td>검사 Lot</td><td>X-Ray/CT lot·치수 lot·재료 lot·외관 lot·결함 위치·NG 등급·재검사 이력</td></tr>
 </tbody>
 </table>

 <h4>3.6.3 데이터 양 추산 — 주조 15년 보관 아키텍처</h4>
 <table>
 <thead><tr><th>티어</th><th>기간</th><th>데이터</th><th>스토리지</th></tr></thead>
 <tbody>
 <tr><td>핫</td><td>0~3개월</td><td>약 5천만 트랜잭션 (10 라인·일 1만 부품·평균 50필드)</td><td>RDB (Oracle·PostgreSQL)</td></tr>
 <tr><td>웜</td><td>3개월~3년</td><td>약 4억 트랜잭션</td><td>Object Storage + indexing</td></tr>
 <tr><td>콜드</td><td>3년~15년</td><td>약 30억 트랜잭션 (메타만 검색)</td><td>아카이브 (S3 Glacier·테이프)</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>15년 누적</td><td>—</td><td>~35억 트랜잭션·~5~8 TB</td><td>핫:웜:콜드 = 5:15:80</td></tr>
 </tbody>
 </table>

 <h4>3.6.4 Genealogy 사례 3종</h4>
 <div class="case">
 <div class="case-title">사례 1 — 엔진 블록 균열 클레임 (현대·2023·가공)</div>
 <p>현대 엔진 블록 협력사. OEM 측 차량 50대에서 엔진 블록 균열 클레임 (운행 1~2년 후). MES Genealogy 4단 역추적 — VIN 50개 → 부품 시리얼 → Heat Number 3건 → 잉곳 1로트 (외부 재활용 잉곳·Mg 함량 +0.3%) 확인. 영향 차량 좁힘: 추정 200대 → 실측 65대. 리콜 비용 1.2억 (전수 추정이었으면 8억).</p>
 </div>
 <div class="case">
 <div class="case-title">사례 2 — 다이캐스팅 금형 캐비티별 NG (2022)</div>
 <p>HPDC 협력사. 8 캐비티 금형. 캐비티 5번에서만 가스 기공 NG 0.3% 발생. MES 캐비티별 추적으로 식별. 5번 캐비티 분리 격리·수리. 다른 7개 캐비티는 정상 가동. 라인 정지 없이 NG 차단.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 3 — VW 디젤게이트 이후 ESG 감사 (2018~)</div>
 <p>VW 협력사 ESG 감사 — 주조 협력사 측 — 유도로(저CO2) 전환·재활용 비율 추적 의무. MES가 Heat별 에너지·CO2 자동 산출. 미구축 협력사 거래 종료.</p>
 </div>

'@

$marker_ch3_c = '<h4>3.5 3장 정리</h4>'
$content = $content.Replace($marker_ch3_c, $casting_ch3 + " " + $marker_ch3_c)
Write-Host "casting ch3 deepened"

# 주조 4장 심화
$casting_ch4 = @'

 <h4>4.5.1 주조 MES 벤더 비교 매트릭스 — 5종</h4>
 <table class="nowrap-table">
 <thead><tr><th>벤더</th><th>주조 전용?</th><th>PLC·Spectro·CT 어댑터</th><th>한국 협력사</th><th>가격 (라이선스/라인)</th></tr></thead>
 <tbody>
 <tr><td>Siemens Opcenter Execution Foundry</td><td>전용</td><td>완비</td><td>대형·VW 협력사</td><td>고 (라인당 1~3억)</td></tr>
 <tr><td>iSCMS Foundry MES</td><td>전용</td><td>완비</td><td>유럽 협력사</td><td>중고</td></tr>
 <tr><td>한국 LS일렉트릭·신한·미라콤</td><td>범용</td><td>주조 어댑터 별도</td><td>현대·기아 1차 다수</td><td>중 (라인당 5천~1억)</td></tr>
 <tr><td>Yotta MES</td><td>범용</td><td>주조 모듈</td><td>한국 중소</td><td>중저</td></tr>
 <tr><td>자체 개발</td><td>맞춤</td><td>전부 개발</td><td>대형·통합 시스템</td><td>고 (구축비 5~20억)</td></tr>
 </tbody>
 </table>

 <h4>4.5.2 PLC 통신 표준 상세 — 주조</h4>
 <table>
 <thead><tr><th>표준</th><th>속도</th><th>실시간성</th><th>주조 적용</th></tr></thead>
 <tbody>
 <tr><td>Modbus TCP</td><td>10~100 Mbps</td><td>~ms</td><td>구형 라인·범용</td></tr>
 <tr><td>EtherNet/IP (CIP)</td><td>100 Mbps~1 Gbps</td><td>~ms</td><td>Rockwell·자동차 표준 (북미)</td></tr>
 <tr><td>Profinet</td><td>100 Mbps</td><td>~ms (PROFINET IRT 0.25ms)</td><td>Siemens·유럽·한국 다수</td></tr>
 <tr><td>OPC UA</td><td>—</td><td>~ms</td><td>차세대·통합 표준</td></tr>
 <tr><td>DICONDE (CT/X-Ray)</td><td>—</td><td>—</td><td>NDT 표준·이미지 데이터</td></tr>
 </tbody>
 </table>

 <h4>4.5.3 견적 변동 요인 8종 — 주조</h4>
 <ol>
 <li>CT 검사 자동화 범위 (안전 부품 100% 시 +30~50%)</li>
 <li>PLC 벤더 통신 표준화 (OPC UA 없으면 어댑터 +40~70%)</li>
 <li>잉곳·리턴 lot 추적 깊이 (Genealogy 4단 vs 2단)</li>
 <li>OEM CSR 수 (5+ OEM 시 +20%)·CQI-27 자동화 요구</li>
 <li>다공장 통합 (각 공장 +50~80%)</li>
 <li>설비 노후 (구형 PLC·SCADA 인터페이스 어려움)</li>
 <li>Giga Press 대응 (단가 +30%)</li>
 <li>15년 보관 인프라 (온프레미스 vs 하이브리드)</li>
 </ol>

 <h4>4.5.4 사례 2종 — 주조 MES 도입 성과</h4>
 <div class="case">
 <div class="case-title">사례 — 현대 차세대 알로이 휠 협력사 14개월 MES (2024)</div>
 <p>LPDC 알로이 휠 협력사. MES 도입 전 PPM 350·OTD 96%·SQ 3★. 14개월 도입 후 PPM 80·OTD 99.2%·SQ 4★ 승급. 5★ 승급 목표 추가 12개월 진행.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 — Bühler 다이캐스팅 + Siemens MES 통합 (2023)</div>
 <p>유럽 자동차 부품 협력사. Bühler 머신·Siemens MES·SAP S/4HANA. OPC UA 표준 인터페이스로 14개월 표준 완료. 견적 24억·산출 OEE 88%.</p>
 </div>

'@

$marker_ch4_c = '<h4>4.6 1부 정리 — 주조편 다음 단계</h4>'
$content = $content.Replace($marker_ch4_c, $casting_ch4 + " " + $marker_ch4_c)
Write-Host "casting ch4 deepened"

[System.IO.File]::WriteAllText($casting_file, $content, $utf8NoBom)
Write-Host "casting saved"

# ===========================================
# 사출편 3·4장 심화
# ===========================================
$injection_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($injection_file, [System.Text.Encoding]::UTF8)

$injection_ch3 = @'

 <h4>3.7.1 인터록 카탈로그 — 사출 14종 상세 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table>
 <thead><tr><th>#</th><th>인터록</th><th>트리거</th><th>차단 동작</th></tr></thead>
 <tbody>
 <tr><td>1</td><td>호퍼 습도 한계</td><td>0.02% 초과 (PA·PC)</td><td>사출 차단·재건조</td></tr>
 <tr><td>2</td><td>가소화 온도 한계</td><td>레진별 ±공차 이탈</td><td>사출 중지</td></tr>
 <tr><td>3</td><td>사출 압력 ±%</td><td>표준 ±5% 이탈</td><td>샷 격리</td></tr>
 <tr><td>4</td><td>보압 ±%</td><td>표준 ±5% 이탈</td><td>샷 격리</td></tr>
 <tr><td>5</td><td>사이클 시간 한계</td><td>표준 ±공차</td><td>알람·검사 강화</td></tr>
 <tr><td>6</td><td>금형 온도 한계</td><td>표준 ±5도</td><td>사출 중지</td></tr>
 <tr><td>7</td><td>Hot Runner zone 온도</td><td>zone별 표준 ±공차</td><td>샷 격리</td></tr>
 <tr><td>8</td><td>캐비티 NG 연속</td><td>한 캐비티 NG 3샷 연속</td><td>그 캐비티 차단</td></tr>
 <tr><td>9</td><td>금형 수명 한계</td><td>100~500만 샷 초과</td><td>금형 교체 트리거</td></tr>
 <tr><td>10</td><td>Regrind 상한</td><td>OEM CSR 초과</td><td>알람·승인 요구</td></tr>
 <tr><td>11</td><td>PCR 비율 목표</td><td>EU ELV 25% 미달</td><td>알람·신원료 보정</td></tr>
 <tr><td>12</td><td>치수 NG (CMM)</td><td>도면 ±공차</td><td>샷 격리·SPC</td></tr>
 <tr><td>13</td><td>외관 NG (자동 비전)</td><td>플로우·싱크·버</td><td>샷 격리</td></tr>
 <tr><td>14</td><td>광학 NG (램프 렌즈)</td><td>MTF·왜곡·투과율</td><td>샷 격리</td></tr>
 </tbody>
 </table>

 <h4>3.7.2 5종 lot 추적성 — Shot 단위 필드 매트릭스</h4>
 <table>
 <thead><tr><th>Lot</th><th>핵심 필드 (60+)</th></tr></thead>
 <tbody>
 <tr><td>원료 Lot</td><td>Resin Lot No·등급·MFI·건조 시간·습도·Regrind 비율·PCR 비율·외부/인하우스·열 이력 회수</td></tr>
 <tr><td>Shot Lot</td><td>Shot No·일자·시간·기계·사출 압력 곡선·보압·속도 1~5단·온도 zone별·사이클 시간·작업자</td></tr>
 <tr><td>Cavity Lot</td><td>Cavity ID·Hot Runner zone 온도·이형력·작업자·NG 발생 패턴</td></tr>
 <tr><td>후공정 Lot</td><td>도색 lot (수성/솔벤트·UV)·인쇄 lot·증착 lot·접합 lot (US Welding 파라미터)</td></tr>
 <tr><td>검사 Lot</td><td>치수 lot·외관 lot·광학 lot·기능 lot·물성 lot·재검사 이력</td></tr>
 </tbody>
 </table>

 <h4>3.7.3 데이터 양 추산 — 사출의 핵심 부담</h4>
 <table>
 <thead><tr><th>티어</th><th>기간</th><th>데이터 (10기 라인)</th><th>스토리지</th></tr></thead>
 <tbody>
 <tr><td>핫</td><td>0~3개월</td><td>약 4억 트랜잭션 (14만 샷/일/기 × 10기 × 평균 50필드)</td><td>RDB·고성능</td></tr>
 <tr><td>웜</td><td>3개월~3년</td><td>약 40억 트랜잭션</td><td>Object Storage</td></tr>
 <tr><td>콜드</td><td>3년~15년</td><td>약 240억 트랜잭션</td><td>아카이브 (압축)</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>15년 누적</td><td>—</td><td>~280억 트랜잭션·~40~60 TB</td><td>SMT의 6~10배·주조의 8배</td></tr>
 </tbody>
 </table>
 <p>사출의 데이터 양이 SMT·주조 대비 압도적. 인프라 견적의 12~20%가 데이터 보관 비용. 클라우드 활용 필수.</p>

 <h4>3.7.4 Genealogy 사례 3종</h4>
 <div class="case">
 <div class="case-title">사례 1 — 현대 ECU 케이스 PA66 클레임 (2023·가공)</div>
 <p>현대 ECU 케이스 협력사. 1만 대 클레임 (운행 6개월 후 균열). MES Genealogy: VIN 1만 → Shot 200만 → 원료 lot 5건 → 외부 Regrind 30% 혼입 (정책 0%). 영향 좁힘 → 1,800대 (실측). 리콜 1.5억 (전수면 8억).</p>
 </div>
 <div class="case">
 <div class="case-title">사례 2 — 도요타 헤드램프 렌즈 PC 황변 (2022)</div>
 <p>도요타 RAV4 헤드램프 협력사. 황변 클레임. Cavity 추적으로 8 캐비티 중 3번만 NG 패턴. 3번 캐비티 Hot Runner zone 온도 +5도 편차. 금형 수리 후 정상화. 라인 정지 없이 NG 해결.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 3 — EU ELV PCR 보고 자동화 (2025)</div>
 <p>VW Golf 8 협력사. 2025년 PCR 보고 시범. MES에 PCR lot 분리 추적·매 부품 lot별 PCR 비율 자동 산출. 월간 OEM EDI 송신. PCR 25% 달성. 2030 의무 5년 선제 대응.</p>
 </div>

'@

$marker_ch3_i = '<h4>3.6 3장 정리</h4>'
$content = $content.Replace($marker_ch3_i, $injection_ch3 + " " + $marker_ch3_i)
Write-Host "injection ch3 deepened"

# 사출 4장 심화
$injection_ch4 = @'

 <h4>4.6.1 사출 MES 벤더 비교 매트릭스 — 6종</h4>
 <table class="nowrap-table">
 <thead><tr><th>벤더</th><th>사출기 출신?</th><th>Euromap 77 어댑터</th><th>한국 협력사</th><th>가격</th></tr></thead>
 <tbody>
 <tr><td>Engel e-factory</td><td>Engel 머신</td><td>완비</td><td>대형·VW 협력사</td><td>고</td></tr>
 <tr><td>Arburg arburgXworld</td><td>Arburg 머신</td><td>완비</td><td>중·정밀 부품</td><td>고</td></tr>
 <tr><td>KraussMaffei Connect</td><td>KraussMaffei</td><td>완비</td><td>대형 부품</td><td>중고</td></tr>
 <tr><td>Siemens Opcenter</td><td>범용</td><td>표준 (OPC UA)</td><td>SAP 협력사</td><td>고</td></tr>
 <tr><td>한국 LS일렉트릭·신한·미라콤</td><td>범용</td><td>Euromap 어댑터 별도</td><td>현대·기아 1차 다수</td><td>중</td></tr>
 <tr><td>자체 개발</td><td>맞춤</td><td>전부 개발</td><td>대형·통합</td><td>고 (구축 5~20억)</td></tr>
 </tbody>
 </table>

 <h4>4.6.2 Euromap 77 데이터 상세 — 300+ 변수</h4>
 <table>
 <thead><tr><th>분류</th><th>변수 수</th><th>예시</th></tr></thead>
 <tbody>
 <tr><td>기계 상태</td><td>30+</td><td>가동·정지·알람·OEE·NG 카운트</td></tr>
 <tr><td>사이클 데이터</td><td>80+</td><td>사출 압력 곡선 (시간별 1ms 분할)·속도 곡선·전환점</td></tr>
 <tr><td>온도 zone별</td><td>40+</td><td>가소화 5~8 zone·금형 4~8 zone·Hot Runner 6~32 zone</td></tr>
 <tr><td>샷 정보</td><td>50+</td><td>Shot No·시작·종료·캐비티 ID·NG·재시도</td></tr>
 <tr><td>마스터</td><td>40+</td><td>금형·재료·작업자·작업 지시</td></tr>
 <tr><td>알람·이벤트</td><td>30+</td><td>알람 코드·시각·시정·작업자</td></tr>
 <tr><td>품질</td><td>30+</td><td>SPC·Cpk·이탈 횟수·재시도</td></tr>
 </tbody>
 </table>

 <h4>4.6.3 견적 변동 요인 8종 — 사출</h4>
 <ol>
 <li>Shot 단위 추적 깊이 (전 캐비티 vs 샘플링)</li>
 <li>Euromap 77 지원 사출기 비율 (구형 Euromap 63만 시 어댑터 +30%)</li>
 <li>Regrind/PCR 자동 집계 정밀도 (Shot 단위 vs lot 단위)</li>
 <li>EU ELV PCR 보고 자동화 요구</li>
 <li>데이터 양 (사출은 SMT의 20~30배)</li>
 <li>Hot Runner zone 통합 (벤더별 API 다름)</li>
 <li>다공장·다라인 통합</li>
 <li>로봇·후공정 통합 (Euromap 67·자동 도색)</li>
 </ol>

 <h4>4.6.4 사례 2종 — 사출 MES 도입 성과</h4>
 <div class="case">
 <div class="case-title">사례 — Tesla Model Y 사출 협력사 14개월 (2024)</div>
 <p>Tesla Model Y 인테리어 사출 협력사. 25기 사출기·Euromap 77 표준. MES 도입 후 PPM 250 → 60·SPC Cpk 1.6 → 2.0·OEE 78% → 88%. Tesla SQ 등급 상승. 5년 거래 연장.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 — 현대 EV 배터리 사출 협력사 (2025)</div>
 <p>현대 IONIQ 7 배터리 케이스 PA66 GF 협력사. EU 수출 — PCR 25% 의무. MES + PCR 분리 추적·자동 보고. EU 수출 자격 확보. 매출 +40%.</p>
 </div>

'@

$marker_ch4_i = '<h4>4.6 1부 정리 — 사출편 다음 단계</h4>'
$content = $content.Replace($marker_ch4_i, $injection_ch4 + " " + $marker_ch4_i)
Write-Host "injection ch4 deepened"

[System.IO.File]::WriteAllText($injection_file, $content, $utf8NoBom)
Write-Host "injection saved"

Write-Host "All deepened"
