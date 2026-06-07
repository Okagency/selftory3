[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 부록 A·D·G 도메인 매트릭스를 부록 H 직후·맺음말 직전에 삽입
$marker = '<hr class="pageline">' + "`r`n" + "`r`n" + '<!-- ============================================================'

function Add-Appendix {
 param($file, $domain_a, $domain_d, $domain_g)
 $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
 # 부록 H 끝 위치 찾기 (맺음말 직전 hr.pageline)
 $endIdx = $content.LastIndexOf('<hr class="pageline">')
 if ($endIdx -lt 0) { Write-Host "marker not found in $file"; return }
 $append = "`r`n" + $domain_a + "`r`n`r`n" + $domain_d + "`r`n`r`n" + $domain_g + "`r`n`r`n"
 $newContent = $content.Substring(0, $endIdx) + $append + $content.Substring($endIdx)
 [System.IO.File]::WriteAllText($file, $newContent, $utf8NoBom)
 Write-Host "$file appendix added"
}

# ===========================================
# 주조편 부록 A·D·G
# ===========================================
$casting_a = @'
<section id="app-a">
 <h2 class="part">부록 A. 주조편 14개월 마일스톤 종합표 <em style="color:#8b3a2a;font-size:14px;font-weight:normal;">(저자 표준화)</em>
 <small>주조 도메인 76 MM 표준 일정·게이트·산출물</small>
 </h2>

 <h4>A.1 14개월 전체 타임라인 — 주조 표준</h4>
 <table>
 <thead><tr><th>월</th><th>단계</th><th>핵심 활동</th><th>게이트·산출물</th></tr></thead>
 <tbody>
 <tr><td>M0</td><td>킥오프</td><td>RACI·위험 v1.0·인터뷰 일정</td><td>킥오프 자료</td></tr>
 <tr><td>M1~M3</td><td>진단 (As-Is)</td><td>인터뷰·라인 관찰 (Spectro·금형·CT)·자료 수집</td><td>G1 — As-Is 보고서·요구 v2.0</td></tr>
 <tr><td>M3~M5</td><td>To-Be</td><td>주조 시나리오 12종·Fit-Gap (PLC·SCADA 어댑터 평가)</td><td>G2 — To-Be 합의</td></tr>
 <tr><td>M5~M7</td><td>설계</td><td>기능 명세·인터페이스 (Spectro·CT·PLC)·마스터 (잉곳·합금·금형)</td><td>G3 — RTM v1.0</td></tr>
 <tr><td>M7~M10</td><td>구축</td><td>컨피그·커스텀·PLC/SCADA 어댑터·Spectro·CT 통합·마이그</td><td>G4 — IT·SIT 통과</td></tr>
 <tr><td>M10~M11</td><td>UAT</td><td>Key User·CT 검사 시나리오·잉곳 추적 검증</td><td>G4 — UAT 통과</td></tr>
 <tr><td>M11~M12</td><td>컷오버</td><td>D-30 점검표·War Room·Final Migration</td><td>G5 — D-Day 안정</td></tr>
 <tr><td>M13~M14</td><td>Hyper Care</td><td>첫 OEM 출하·CT NG 대응·첫 월 마감</td><td>G6 — 정식 운영</td></tr>
 </tbody>
 </table>

 <h4>A.2 단계별 표준 MM — 주조 76 MM</h4>
 <table>
 <thead><tr><th>부</th><th>표준 MM</th><th>주조 특수</th></tr></thead>
 <tbody>
 <tr><td>2부 영업·제안</td><td>3</td><td>—</td></tr>
 <tr><td>3부 진단</td><td>10</td><td>—</td></tr>
 <tr><td>4부 설계</td><td>15</td><td>—</td></tr>
 <tr><td>5부 구축</td><td>25</td><td>+3 (벤더별 PLC 어댑터·CT API)</td></tr>
 <tr><td>6부 테스트</td><td>10</td><td>+2 (CT/X-Ray UAT)</td></tr>
 <tr><td>7부 컷오버</td><td>5</td><td>—</td></tr>
 <tr><td>8부 Hyper Care</td><td>8</td><td>—</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>주조 표준 합계</td><td>76 MM</td><td>+5 vs 공통 표준 71 MM</td></tr>
 </tbody>
 </table>

 <h4>A.3 주조 특수 산출물 5종</h4>
 <ul>
 <li>잉곳·리턴 비율 마스터 (자재 마스터 확장)</li>
 <li>Heat Number 발번 룰·Spectro 매핑</li>
 <li>금형 수명 카운트·예방보전 일정</li>
 <li>CT·X-Ray DICONDE 어댑터 명세</li>
 <li>CQI-27 평가 양식·자동 추출 데이터</li>
 </ul>
</section>
'@

$casting_d = @'
<section id="app-d">
 <h2 class="part">부록 D. 주조편 인터페이스 명세
 <small>주조 라인 7종 인터페이스·통신 표준</small>
 </h2>

 <h4>D.1 7종 인터페이스 종합표</h4>
 <table>
 <thead><tr><th>#</th><th>인터페이스</th><th>통신</th><th>주조 특수</th></tr></thead>
 <tbody>
 <tr><td>IF-1</td><td>MES ↔ ERP</td><td>B2MML</td><td>잉곳/리턴 입고·합금 마스터</td></tr>
 <tr><td>IF-2</td><td>MES ↔ PLM</td><td>OSLC·STEP</td><td>금형 CAD·BOM</td></tr>
 <tr><td>IF-3</td><td>MES ↔ 유도로/다이캐스팅 PLC</td><td>Modbus TCP·EtherNet/IP·Profinet·OPC UA</td><td>용탕 온도·주입 압력·응고 프로파일</td></tr>
 <tr><td>IF-4</td><td>MES ↔ Spectro</td><td>벤더 API (Thermo·Bruker·SPECTRO)</td><td>18종 원소 측정값·합금 표준 비교</td></tr>
 <tr><td>IF-5</td><td>MES ↔ CT·X-Ray</td><td>DICONDE (DICOM for NDT)·벤더 API</td><td>기공·균열 자동 검출·NG lot 격리</td></tr>
 <tr><td>IF-6</td><td>MES ↔ OEM (SQ·EDI)</td><td>EDIFACT·OEM API</td><td>리턴 비율 보고·합금 인증서</td></tr>
 <tr><td>IF-7</td><td>MES ↔ BI·DW</td><td>REST·Kafka·CDC</td><td>SPC·OEE·CQI-27 트렌드</td></tr>
 </tbody>
 </table>

 <h4>D.2 통신 표준 점유율 (자동차 주조 2026)</h4>
 <ul>
 <li>PLC 직결 (Modbus·EtherNet/IP·Profinet) — 60%</li>
 <li>OPC UA — 20% (신규 라인)</li>
 <li>SCADA 통합 (WinCC·System Platform·Wonderware) — 15%</li>
 <li>벤더 자체 API — 5%</li>
 </ul>
</section>
'@

$casting_g = @'
<section id="app-g">
 <h2 class="part">부록 G. 주조편 견적 · MD 산정 <em style="color:#8b3a2a;font-size:14px;font-weight:normal;">(저자 산정 — 2026 한국 시장 기준)</em>
 <small>주조 라인 수별 표준 단가·MM 분배·견적 폭발 방지</small>
 </h2>

 <h4>G.1 라인 수별 표준 단가 — 주조</h4>
 <table>
 <thead><tr><th>규모</th><th>라인 수</th><th>표준 견적 (억)</th><th>MM</th><th>특이</th></tr></thead>
 <tbody>
 <tr><td>소</td><td>1~2 라인 + 후공정</td><td>6~10</td><td>40~55</td><td>중소 협력사·MVP·Phase 2 분할 권장</td></tr>
 <tr><td>중</td><td>3~5 라인 + 열처리·CNC</td><td>12~20</td><td>65~85</td><td>표준 협력사·전체 영역</td></tr>
 <tr><td>대</td><td>6~10 라인 + 2차 공정 (조립·검사)</td><td>22~35</td><td>95~125</td><td>1차 협력사·OEM 직납</td></tr>
 <tr><td>초대</td><td>10+ 라인 + 다공장</td><td>40~70</td><td>140~200</td><td>그룹 협력사·다공장 통합 MES</td></tr>
 </tbody>
 </table>

 <h4>G.2 견적 구성 7항목 비중 (주조)</h4>
 <table>
 <thead><tr><th>항목</th><th>비중</th></tr></thead>
 <tbody>
 <tr><td>인력비</td><td>55~65%</td></tr>
 <tr><td>라이선스 (MES 패키지·Spectro·CT 어댑터)</td><td>12~22%</td></tr>
 <tr><td>인프라 (HW·SW·15년 보관)</td><td>8~14%</td></tr>
 <tr><td>인터페이스 (PLC·SCADA·CT·DICONDE)</td><td>6~12%</td></tr>
 <tr><td>교육·매뉴얼</td><td>2~4%</td></tr>
 <tr><td>유지보수 1년</td><td>5~8%</td></tr>
 <tr><td>관리비·예비비</td><td>3~5%</td></tr>
 </tbody>
 </table>

 <h4>G.3 변동 요인 5종</h4>
 <ol>
 <li>CT 검사 자동화 범위 (안전 부품 100% 시 +30~50%)</li>
 <li>PLC 벤더 통신 표준화 정도 (OPC UA 없으면 어댑터 +40~70%)</li>
 <li>잉곳·리턴 lot 추적 깊이 (Genealogy 4단 vs 2단)</li>
 <li>OEM CSR 수·CQI-27 자동화 요구</li>
 <li>다공장 통합 여부 (각 공장 +50~80%)</li>
 </ol>
</section>
'@

# ===========================================
# 사출편 부록 A·D·G
# ===========================================
$injection_a = @'
<section id="app-a">
 <h2 class="part">부록 A. 사출편 14개월 마일스톤 종합표 <em style="color:#8b3a2a;font-size:14px;font-weight:normal;">(저자 표준화)</em>
 <small>사출 도메인 74 MM 표준 일정·게이트·산출물</small>
 </h2>

 <h4>A.1 14개월 전체 타임라인 — 사출 표준</h4>
 <table>
 <thead><tr><th>월</th><th>단계</th><th>핵심 활동</th><th>게이트·산출물</th></tr></thead>
 <tbody>
 <tr><td>M0</td><td>킥오프</td><td>RACI·위험 v1.0·인터뷰 일정</td><td>킥오프 자료</td></tr>
 <tr><td>M1~M3</td><td>진단</td><td>인터뷰·라인 관찰 (사출기·금형·캐비티·후공정)·자료 수집</td><td>G1 — As-Is·요구 v2.0</td></tr>
 <tr><td>M3~M5</td><td>To-Be</td><td>사출 시나리오 12종·Fit-Gap (Euromap 77 어댑터 평가)</td><td>G2 — To-Be 합의</td></tr>
 <tr><td>M5~M7</td><td>설계</td><td>기능 명세·인터페이스 (Euromap·로봇·후공정)·마스터 (레진·금형·캐비티·Regrind)</td><td>G3 — RTM v1.0</td></tr>
 <tr><td>M7~M10</td><td>구축</td><td>컨피그·커스텀·Euromap 77/63 어댑터·로봇 통합·마이그</td><td>G4 — IT·SIT 통과</td></tr>
 <tr><td>M10~M11</td><td>UAT</td><td>Key User·Shot 단위 추적 검증·Regrind/PCR 자동 집계</td><td>G4 — UAT 통과</td></tr>
 <tr><td>M11~M12</td><td>컷오버</td><td>D-30·War Room·Final Migration</td><td>G5 — D-Day 안정</td></tr>
 <tr><td>M13~M14</td><td>Hyper Care</td><td>첫 OEM 출하·Shot 데이터 양 안정·첫 월 마감</td><td>G6 — 정식 운영</td></tr>
 </tbody>
 </table>

 <h4>A.2 단계별 표준 MM — 사출 74 MM</h4>
 <table>
 <thead><tr><th>부</th><th>표준 MM</th><th>사출 특수</th></tr></thead>
 <tbody>
 <tr><td>2부 영업·제안</td><td>3</td><td>—</td></tr>
 <tr><td>3부 진단</td><td>10</td><td>—</td></tr>
 <tr><td>4부 설계</td><td>15</td><td>—</td></tr>
 <tr><td>5부 구축</td><td>24</td><td>+2 (Euromap 77 표준 활용·어댑터 짧음)</td></tr>
 <tr><td>6부 테스트</td><td>10</td><td>+2 (Shot 데이터 양 검증)</td></tr>
 <tr><td>7부 컷오버</td><td>5</td><td>—</td></tr>
 <tr><td>8부 Hyper Care</td><td>7</td><td>−1 (Shot 데이터 자동 안정화)</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>사출 표준 합계</td><td>74 MM</td><td>+3 vs 공통 표준 71 MM</td></tr>
 </tbody>
 </table>

 <h4>A.3 사출 특수 산출물 5종</h4>
 <ul>
 <li>레진·Regrind·PCR 비율 마스터 (자재 마스터 확장)</li>
 <li>Shot Number + Cavity ID 발번 룰</li>
 <li>금형·Hot Runner zone 마스터·수명 카운트</li>
 <li>Euromap 77 어댑터 명세 + 사이클 데이터 매핑</li>
 <li>CQI-23 평가 양식·EU ELV PCR 보고 자동화</li>
 </ul>
</section>
'@

$injection_d = @'
<section id="app-d">
 <h2 class="part">부록 D. 사출편 인터페이스 명세
 <small>사출 라인 7종 인터페이스·Euromap 표준</small>
 </h2>

 <h4>D.1 7종 인터페이스 종합표</h4>
 <table>
 <thead><tr><th>#</th><th>인터페이스</th><th>통신</th><th>사출 특수</th></tr></thead>
 <tbody>
 <tr><td>IF-1</td><td>MES ↔ ERP</td><td>B2MML</td><td>레진/Regrind/PCR 입고·인증서</td></tr>
 <tr><td>IF-2</td><td>MES ↔ PLM</td><td>OSLC·STEP</td><td>금형 CAD·캐비티·BOM</td></tr>
 <tr><td>IF-3</td><td>MES ↔ 사출기</td><td><strong>Euromap 77 (OPC UA Companion)·Euromap 63 (XML)</strong></td><td>Shot 단위 사이클·압력·온도 (300+ 변수)</td></tr>
 <tr><td>IF-4</td><td>MES ↔ Hot Runner 컨트롤러</td><td>벤더 API (Mold-Masters·Husky·INCOE)</td><td>zone별 온도·MES 통합</td></tr>
 <tr><td>IF-5</td><td>MES ↔ 로봇 (인출)</td><td><strong>Euromap 67</strong>·OPC UA</td><td>인출·이송·후공정 라우팅</td></tr>
 <tr><td>IF-6</td><td>MES ↔ OEM (SQ·EDI)</td><td>EDIFACT·OEM API</td><td>Regrind/PCR 보고·EU ELV PCR ≥25%</td></tr>
 <tr><td>IF-7</td><td>MES ↔ BI·DW</td><td>REST·Kafka·CDC</td><td>Shot 데이터·SPC·OEE·CQI-23</td></tr>
 </tbody>
 </table>

 <h4>D.2 통신 표준 점유율 (자동차 사출 2026)</h4>
 <ul>
 <li><strong>Euromap 77 (OPC UA)</strong> — 55% (신규·교체 사출기 표준)</li>
 <li>Euromap 63 (XML) — 30% (구형 사출기·아직 다수)</li>
 <li>벤더 자체 API — 10%</li>
 <li>PLC 직결 (Modbus·구형) — 5%</li>
 </ul>

 <h4>D.3 Euromap 77 핵심 데이터 300+ 변수</h4>
 <ul>
 <li>기계 상태 — 가동·정지·알람·OEE</li>
 <li>사이클 데이터 — 사출 압력 곡선·속도 곡선·시간 분할</li>
 <li>온도 — 가소화 zone·금형·Hot Runner zone</li>
 <li>Shot 카운트·NG 카운트·캐비티별 분리</li>
 <li>금형·재료·작업자 마스터 매핑</li>
 </ul>
</section>
'@

$injection_g = @'
<section id="app-g">
 <h2 class="part">부록 G. 사출편 견적 · MD 산정 <em style="color:#8b3a2a;font-size:14px;font-weight:normal;">(저자 산정 — 2026 한국 시장 기준)</em>
 <small>사출기 수별 표준 단가·MM 분배·견적 폭발 방지</small>
 </h2>

 <h4>G.1 사출기 수별 표준 단가 — 사출</h4>
 <table>
 <thead><tr><th>규모</th><th>사출기 수</th><th>표준 견적 (억)</th><th>MM</th><th>특이</th></tr></thead>
 <tbody>
 <tr><td>소</td><td>1~5 기 + 후공정</td><td>5~9</td><td>35~50</td><td>중소 협력사·MVP</td></tr>
 <tr><td>중</td><td>6~15 기 + 도색·조립</td><td>10~18</td><td>60~80</td><td>표준 협력사</td></tr>
 <tr><td>대</td><td>16~40 기 + 다중 후공정·100% Shot 추적</td><td>20~38</td><td>90~130</td><td>1차 협력사·OEM 직납</td></tr>
 <tr><td>초대</td><td>40+ 기 + 다공장</td><td>40~75</td><td>140~210</td><td>그룹 협력사·통합 MES + 핫/웜/콜드 아키텍처 대규모</td></tr>
 </tbody>
 </table>

 <h4>G.2 견적 구성 7항목 비중 (사출)</h4>
 <table>
 <thead><tr><th>항목</th><th>비중</th></tr></thead>
 <tbody>
 <tr><td>인력비</td><td>50~60%</td></tr>
 <tr><td>라이선스 (MES 패키지·Euromap 어댑터)</td><td>10~18%</td></tr>
 <tr><td>인프라 (HW·SW·핫/웜/콜드 — 사출 데이터 양 ★)</td><td>12~20%</td></tr>
 <tr><td>인터페이스 (Euromap 77·63·로봇·Hot Runner)</td><td>5~10%</td></tr>
 <tr><td>교육·매뉴얼</td><td>2~4%</td></tr>
 <tr><td>유지보수 1년</td><td>5~8%</td></tr>
 <tr><td>관리비·예비비</td><td>3~5%</td></tr>
 </tbody>
 </table>

 <h4>G.3 변동 요인 5종</h4>
 <ol>
 <li>Shot 단위 추적 깊이 (전 캐비티 vs 샘플링)</li>
 <li>Euromap 77 지원 사출기 비율 (구형 Euromap 63만 시 어댑터 +30%)</li>
 <li>Regrind/PCR 자동 집계 정밀도 (Shot 단위 vs lot 단위)</li>
 <li>EU ELV PCR 보고 자동화 요구</li>
 <li>데이터 양 (사출은 SMT의 20~30배 — 핫/웜/콜드 인프라 비용 큰 비중)</li>
 </ol>
</section>
'@

Add-Appendix "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html" $casting_a $casting_d $casting_g
Add-Appendix "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html" $injection_a $injection_d $injection_g

Write-Host "All appendix done"
