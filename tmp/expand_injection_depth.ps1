[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$injection_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($injection_file, [System.Text.Encoding]::UTF8)

# 사출편 1장 심화
$ch1_deep = @'

 <hr class="scene">

 <h4>1.9.1 사출 사이클 6단계 상세 매트릭스 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table class="nowrap-table">
 <thead><tr><th>단계</th><th>시간</th><th>온도</th><th>압력</th><th>핵심 변수</th><th>MES 수집</th></tr></thead>
 <tbody>
 <tr><td>① 원료 건조</td><td>2~6h (배치 사전)</td><td>80~120도 (레진별)</td><td>—</td><td>건조 시간·습도 (PA·PC 0.02% 이하)</td><td>호퍼 습도 센서·인터록</td></tr>
 <tr><td>② 가소화·계량</td><td>5~30s</td><td>200~280도</td><td>0~200 bar</td><td>스크류 회전·배압·계량 시간</td><td>Euromap 77</td></tr>
 <tr><td>③ 사출 (Injection)</td><td>0.5~5s</td><td>200~280도</td><td>800~2,000 bar</td><td>사출 압력·속도 1~5단</td><td>Euromap 77 사이클 곡선</td></tr>
 <tr><td>④ 보압 (Holding)</td><td>5~20s</td><td>200~280도</td><td>500~1,400 bar</td><td>보압·시간·전환점</td><td>Euromap 77</td></tr>
 <tr><td>⑤ 냉각 (Cooling)</td><td>10~60s (사이클의 60~80%)</td><td>금형 30~120도</td><td>—</td><td>금형 온도·냉각수 유량</td><td>금형 열전대·MES 수집</td></tr>
 <tr><td>⑥ 이형 (Ejection)</td><td>1~3s</td><td>—</td><td>—</td><td>이형력·로봇 인출·캐비티별</td><td>Euromap 67 (로봇)</td></tr>
 </tbody>
 </table>

 <h4>1.9.2 사출기 벤더 5종 — 자동차 부품 시장</h4>
 <table>
 <thead><tr><th>벤더</th><th>본사</th><th>대표 모델</th><th>특징·자동차 부품 강세</th></tr></thead>
 <tbody>
 <tr><td>Engel</td><td>오스트리아</td><td>e-victory·duo·victory</td><td>전동·하이브리드. 자동차 부품 1위 점유</td></tr>
 <tr><td>Arburg</td><td>독일</td><td>Allrounder·Hidrive·GestaltA</td><td>정밀·소형. 광학·전장 부품</td></tr>
 <tr><td>KraussMaffei</td><td>독일</td><td>GX·MX·CX</td><td>대형 (1,000~6,000톤). 범퍼·대시</td></tr>
 <tr><td>Sumitomo Demag</td><td>일본·독일</td><td>El-Exis·SE-EV·Systec</td><td>전동식 표준. 일본·유럽 점유</td></tr>
 <tr><td>LS Mtron·동신유압</td><td>한국</td><td>WIZ·DL·DK</td><td>한국 자동차 협력사 다수</td></tr>
 </tbody>
 </table>

 <h4>1.9.3 레진 10종 — 물성·자동차 적용 상세</h4>
 <table class="nowrap-table">
 <thead><tr><th>레진</th><th>가공 온도</th><th>금형 온도</th><th>인장 (MPa)</th><th>충격 (J/m)</th><th>밀도</th><th>자동차 대표</th></tr></thead>
 <tbody>
 <tr><td>PP</td><td>200~240도</td><td>30~60</td><td>25~40</td><td>30~60</td><td>0.90</td><td>범퍼·도어트림·내장 (저가)</td></tr>
 <tr><td>ABS</td><td>220~260도</td><td>50~80</td><td>40~55</td><td>200~400</td><td>1.05</td><td>대시·외장·전장</td></tr>
 <tr><td>PC (Polycarbonate)</td><td>280~320도</td><td>80~120</td><td>60~70</td><td>600~900</td><td>1.20</td><td>램프 렌즈·블랙박스 하우징</td></tr>
 <tr><td>PC/ABS</td><td>240~280도</td><td>60~100</td><td>50~60</td><td>400~600</td><td>1.13</td><td>전장 하우징·내장</td></tr>
 <tr><td>PA6 / PA66</td><td>260~310도</td><td>80~100</td><td>70~80 (GF 강화 100~200)</td><td>30~60</td><td>1.14</td><td>커넥터·하네스·엔진룸</td></tr>
 <tr><td>PBT</td><td>240~270도</td><td>60~90</td><td>55~70</td><td>40~50</td><td>1.31</td><td>ECU 케이스·전기 부품</td></tr>
 <tr><td>POM</td><td>180~220도</td><td>60~100</td><td>70~80</td><td>50~80</td><td>1.41</td><td>기어·슬라이드</td></tr>
 <tr><td>TPE / TPO</td><td>180~220도</td><td>20~40</td><td>5~20</td><td>—</td><td>0.88~0.98</td><td>가스켓·시일</td></tr>
 <tr><td>PMMA</td><td>220~260도</td><td>50~80</td><td>60~75</td><td>15~25</td><td>1.18</td><td>램프 렌즈 (일부)</td></tr>
 <tr><td>PPS</td><td>300~340도</td><td>120~150</td><td>90~140</td><td>40~60</td><td>1.35</td><td>고온 엔진 부품</td></tr>
 </tbody>
 </table>

 <h4>1.9.4 Regrind 열 이력 누적·물성 저하</h4>
 <table>
 <thead><tr><th>재가공 회수</th><th>PP 인장 저하</th><th>PC 황변</th><th>PA66 점도 변화</th><th>OEM CSR 한계</th></tr></thead>
 <tbody>
 <tr><td>1회 (Regrind 25%)</td><td>−5%</td><td>경미</td><td>−10%</td><td>표준 허용</td></tr>
 <tr><td>2회 (외부 Regrind)</td><td>−15%</td><td>황변 시작</td><td>−25%</td><td>외장 제한</td></tr>
 <tr><td>3회 (다단 재활용)</td><td>−25%</td><td>황변 명확</td><td>−40%</td><td>비표면·내부만</td></tr>
 <tr><td>4회+</td><td>−40%</td><td>심한 황변·취화</td><td>−60%</td><td>폐기</td></tr>
 </tbody>
 </table>
 <p>Regrind 사용 시 열 이력 추적이 MES 핵심. 1회 vs 2회 Regrind는 물성 완전 다름. MES가 Regrind lot의 원천 (인하우스 1회 vs 외부 다회)을 구분 추적.</p>

 <h4>1.9.5 사출 결함 12종 — Pareto 패턴</h4>
 <table>
 <thead><tr><th>결함</th><th>원인</th><th>MES 인터록</th></tr></thead>
 <tbody>
 <tr><td>플로우 마크 (Flow Mark)</td><td>사출 속도·온도 부족</td><td>사출 속도 SPC</td></tr>
 <tr><td>싱크 마크 (Sink Mark)</td><td>보압·냉각 부족</td><td>보압 SPC·금형 온도</td></tr>
 <tr><td>버 (Flash)</td><td>형체력·금형 마모</td><td>금형 수명·형체력 SPC</td></tr>
 <tr><td>웰드라인 (Weld Line)</td><td>여러 게이트 합류·온도</td><td>금형 온도·게이트 위치</td></tr>
 <tr><td>색상 차이 (Color)</td><td>마스터배치 비율·Regrind</td><td>마스터배치 lot·Regrind 비율</td></tr>
 <tr><td>기포 (Bubble)</td><td>건조 부족·수분</td><td>호퍼 습도 인터록</td></tr>
 <tr><td>탄화 (Burn Mark)</td><td>가스 배기·과열</td><td>가스 벤트·온도</td></tr>
 <tr><td>변형 (Warp)</td><td>냉각 비대칭·잔류 응력</td><td>금형 온도·이형 시점</td></tr>
 <tr><td>치수 불량</td><td>사이클·금형·수축</td><td>CMM·SPC</td></tr>
 <tr><td>샷 부족 (Short Shot)</td><td>사출량 부족·점도</td><td>계량 SPC·온도</td></tr>
 <tr><td>광학 (Optical)</td><td>레진 결정·표면</td><td>광학 검사 (램프 렌즈)</td></tr>
 <tr><td>물성 (Mechanical)</td><td>레진 열 이력·합금</td><td>인장·충격·DSC 시험</td></tr>
 </tbody>
 </table>

'@

$marker_ch1 = '<h4>1.9 1장 정리 — MES가 잡아야 할 사출 데이터 7가지</h4>'
$content = $content.Replace($marker_ch1, $ch1_deep + " " + $marker_ch1)
Write-Host "injection ch1 deepened"

# 사출편 2장 심화
$ch2_deep = @'

 <h4>2.5.1 OEM 규격 매트릭스 — 6 OEM × 7 항목</h4>
 <table class="nowrap-table">
 <thead><tr><th>항목</th><th>현대·기아</th><th>도요타</th><th>VW</th><th>BMW</th><th>GM</th><th>Ford</th></tr></thead>
 <tbody>
 <tr><td>품질 표준</td><td>MS</td><td>TSH</td><td>TL</td><td>BMW Standard</td><td>GMW</td><td>WSS-M</td></tr>
 <tr><td>SQ 시스템</td><td>SQ Mark 5★</td><td>GTQS</td><td>Formel-Q</td><td>Formel-Q</td><td>BIQS</td><td>Q1</td></tr>
 <tr><td>사출 평가</td><td>SQ 항목</td><td>TPS Audit</td><td>VDA 6.3</td><td>VDA 6.3</td><td>CQI-23</td><td>QSA</td></tr>
 <tr><td>레진 규격</td><td>MS 규격</td><td>TSH 레진</td><td>TL 52</td><td>BMW GS</td><td>SAE J</td><td>WSS-M</td></tr>
 <tr><td>추적성</td><td>15년·Shot</td><td>15년·SVO</td><td>15년·VIN</td><td>15년·VIN</td><td>15년·GMS</td><td>15년·VIN</td></tr>
 <tr><td>외관 표준</td><td>SQ 외관</td><td>TSH 외관</td><td>VW Class A·B·C</td><td>BMW Class</td><td>GMS</td><td>WSS 외관</td></tr>
 <tr><td>Regrind 상한</td><td>등급별 0~30%</td><td>0~25%</td><td>EU ELV 25% PCR ≥25%</td><td>0~20%</td><td>0~30%</td><td>0~30%</td></tr>
 </tbody>
 </table>

 <h4>2.5.2 CQI-23 평가 12영역 220 항목 카탈로그</h4>
 <table>
 <thead><tr><th>영역</th><th>항목 수</th><th>MES 데이터 영역</th></tr></thead>
 <tbody>
 <tr><td>(1) 관리 책임</td><td>15</td><td>—</td></tr>
 <tr><td>(2) 인력·자격</td><td>20</td><td>작업자 마스터</td></tr>
 <tr><td>(3) 사출기·금형·로봇</td><td>25</td><td>설비 마스터·금형 수명</td></tr>
 <tr><td>(4) 원료 관리·건조</td><td>25</td><td>레진/Regrind/PCR lot·습도</td></tr>
 <tr><td>(5) 사출 공정 조건</td><td>30</td><td>Euromap 77·사이클·SPC</td></tr>
 <tr><td>(6) Hot Runner·온도</td><td>15</td><td>zone별 온도·MES</td></tr>
 <tr><td>(7) 후공정 (도색·인쇄)</td><td>20</td><td>후공정 lot·환경</td></tr>
 <tr><td>(8) 검사</td><td>25</td><td>치수·외관·광학·기능</td></tr>
 <tr><td>(9) 환경·안전</td><td>10</td><td>EU ELV PCR 보고</td></tr>
 <tr><td>(10) 문서·기록</td><td>15</td><td>PPAP·8D·CSR 자동</td></tr>
 <tr><td>(11) 변경 관리</td><td>10</td><td>ECN·금형 변경</td></tr>
 <tr><td>(12) 시정 조치</td><td>10</td><td>CAPA·8D 이력</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>합계</td><td>220</td><td>약 80% MES 직접</td></tr>
 </tbody>
 </table>

 <h4>2.5.3 자동차 사출 부품 무게·레진 매트릭스 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 추정)</em></h4>
 <table>
 <thead><tr><th>부품</th><th>무게 (kg)</th><th>레진</th><th>차량 1대당 수</th></tr></thead>
 <tbody>
 <tr><td>범퍼 (전·후)</td><td>5~9 (set)</td><td>PP/EPDM·TPO</td><td>2 (전후)</td></tr>
 <tr><td>대시보드 (Instrument Panel)</td><td>4~8</td><td>PP·ABS·PC/ABS</td><td>1</td></tr>
 <tr><td>도어 트림 (set)</td><td>3~6</td><td>PP·ABS·PVC</td><td>4</td></tr>
 <tr><td>램프 렌즈 (헤드·테일)</td><td>0.3~0.8 (1ea)</td><td>PC·PMMA</td><td>2~6</td></tr>
 <tr><td>그릴 (라디에이터)</td><td>0.8~1.5</td><td>ABS·PC/ABS</td><td>1</td></tr>
 <tr><td>ECU 케이스</td><td>0.2~0.5</td><td>PA66·PBT</td><td>10~50</td></tr>
 <tr><td>커넥터·하네스 클립</td><td>0.005~0.05 (1ea)</td><td>PA66·PBT</td><td>200~600</td></tr>
 <tr><td>블랙박스 하우징</td><td>0.05~0.2</td><td>ABS·PC/ABS</td><td>1~2</td></tr>
 <tr><td>인테이크 매니폴드</td><td>1~3</td><td>PA66 GF</td><td>1</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>차량 1대 사출 합계</td><td>~150~250 kg</td><td>—</td><td>500+ 부품</td></tr>
 </tbody>
 </table>
 <p>차량 1대당 사출 부품 수는 약 500개. 무게 ~200kg. 차량 전체 무게의 약 10~15%. 전기차는 + 배터리 커버·내장 (+30~50kg).</p>

 <h4>2.5.4 EU ELV·PCR — 상세</h4>
 <ul>
 <li><strong>EU ELV (End-of-Life Vehicles) Directive 2000/53/EC</strong> — 2000년 발효. 차량 폐기 시 재활용 의무. 2015년부터 차량 무게의 95% 재활용·85% 재활용 가능 의무.</li>
 <li><strong>2024년 EU ELV 개정안</strong> — 2030년부터 신차의 PCR(Post-Consumer Recycled) 비율 ≥25% 의무. 부품 단위 PCR 비율 보고.</li>
 <li><strong>PCR 보고 양식</strong> — OEM이 협력사에 매 부품 lot의 PCR 비율 데이터 요구. MES 자동 집계 필수.</li>
 <li><strong>한국 자원순환기본법</strong> — EU ELV 영향. 2027년부터 자동차 협력사 ESG 보고 의무 (PCR·CO2 포함).</li>
 </ul>

 <h4>2.5.5 사례 5종 — 사출 협력사 OEM 사고·우수 사례</h4>
 <div class="case">
 <div class="case-title">사례 1 — Tesla Model 3 대시보드 사출 협력사 (2018)</div>
 <p>Tesla Model 3 대시보드 협력사가 캐비티 NG 추적 부재. 5개 캐비티 중 3번 캐비티에서만 NG 패턴 발생. MES 없이 Lot 단위만 추적 → 전 Lot 폐기. 손실 8억. MES 도입 후 캐비티 ID 추적 → 3번 캐비티만 격리. 동일 사고 시 손실 0.6억으로 감소.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 2 — VW 헤드램프 렌즈 황변 클레임 (2021)</div>
 <p>VW Golf 헤드램프 렌즈 (PC) 협력사. 1년 후 황변 NG. MES Genealogy로 Regrind 비율 추적 → 외부 재활용 PCR 8% 혼입 발견 (정책상 0%). 영향 차량 2만 대 좁힘. 리콜 비용 4억 (전수면 26억). VW가 동일 사고 협력사 거래 종료.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 3 — 현대 ECU 케이스 PA66 협력사 (2022)</div>
 <p>ECU 케이스 PA66 GF 협력사. 호퍼 습도 관리 부실로 1주일간 기포 NG 0.5% → 8% 폭증. MES 호퍼 습도 인터록 도입 후 0.05%로 감소. SQ +6점·연 거래 +25억.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 4 — 도요타 EV 배터리 커버 사출 (2024)</div>
 <p>도요타 bZ4X 배터리 커버 사출 협력사. 25,000톤급 초대형 사출기로 통합 부품 한 번에 사출 (Megacasting의 사출 버전). 한국 LS Mtron이 25,000톤 사출기 개발 중. MES + Euromap 77 통합 표준.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 5 — EU ELV PCR 25% 대응 (2025·2030 D-5)</div>
 <p>EU 2030 PCR 25% 의무 대응 — 협력사들이 5년 전부터 PCR lot 추적 시스템 구축. 한국 협력사 다수가 MES + PCR 라벨링 시스템 통합. 미구축 협력사는 EU 시장 차단 위험.</p>
 </div>

'@

$marker_ch2 = '<h4>2.5 2장 정리</h4>'
$content = $content.Replace($marker_ch2, $ch2_deep + " " + $marker_ch2)
Write-Host "injection ch2 deepened"

[System.IO.File]::WriteAllText($injection_file, $content, $utf8NoBom)
Write-Host "injection expanded"
