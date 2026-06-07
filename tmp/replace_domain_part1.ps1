[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# ===========================================
# 주조편
# ===========================================
$file_c = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($file_c, [System.Text.Encoding]::UTF8)
$startIdx = $content.IndexOf('<section id="ch1-wrap">')
$marker = "<!-- ============================================================`n 제2부"
$endIdx = $content.IndexOf($marker)
if ($startIdx -lt 0 -or $endIdx -lt 0) { Write-Host "casting marker not found ($startIdx, $endIdx)"; exit 1 }

$casting = @'
<section id="ch1-wrap">
 <h3 class="chapter" id="ch1">1장 주조 공정 — 용해부터 검사까지
 <small>주조 5대 분류·자동차 주조 부품·공정 흐름·MES가 잡아야 할 데이터</small>
 </h3>

 <p>주조(Casting)는 금속을 용해해 주형에 부어 응고시켜 부품을 만드는 공정이다. 자동차 산업에서 엔진 블록·실린더 헤드·미션 케이스·휠·서스펜션·브래킷·하우징 등 안전·구조 부품의 대부분이 주조로 만들어진다. 한 부품이 무너지면 차량 폐기로 직결되는 영역. SMT의 PCBA가 자동차의 "신경"이라면, 주조 부품은 자동차의 "뼈"다.</p>

 <h4>1.1 주조 공정 5대 분류</h4>
 <table>
 <thead><tr><th>방식</th><th>주조 압력</th><th>대표 부품</th><th>특징</th></tr></thead>
 <tbody>
 <tr><td>사형주조 (Sand Casting)</td><td>중력</td><td>엔진 블록·미션 케이스·대형 브래킷</td><td>저비용·복잡 형상·표면 조도 낮음</td></tr>
 <tr><td>중력 다이캐스팅 (Gravity Die Casting)</td><td>중력</td><td>실린더 헤드·휠 (일부)</td><td>금속 금형·중간 표면·중간 생산성</td></tr>
 <tr><td>저압 다이캐스팅 (LPDC)</td><td>0.3~1 bar</td><td>알루미늄 휠·서스펜션 암</td><td>치밀·기공 적음·휠에 표준</td></tr>
 <tr><td>고압 다이캐스팅 (HPDC)</td><td>700~1,000 bar</td><td>미션 케이스·엔진 블록·구조 부품</td><td>고생산성·고정밀·기공 가능성</td></tr>
 <tr><td>로스트 왁스 (Investment Casting)</td><td>중력</td><td>터빈 블레이드·정밀 부품</td><td>최고 정밀·고비용·소량 생산</td></tr>
 </tbody>
 </table>
 <p>자동차 부품 협력사 다수가 HPDC(고압 다이캐스팅) 중심. 알루미늄 합금(ADC12·A380·AC2B 등)으로 미션 케이스·엔진 블록·구조 부품을 양산.</p>

 <h4>1.2 주조 라인 흐름 — 9단계</h4>
 <div class="flow">[주조 라인 표준 9단계 — HPDC 기준]

  (1) 원자재 입고     (잉곳·리턴 자재·합금 원소)
  (2) 용해 (Melting)  (유도로·반사로·전기로 — 700~800℃)
  (3) 성분 검사       (Spectro 분광 분석 18종 원소)
  (4) 보온로 이송     (Holding Furnace — 슬리브 온도 유지)
  (5) 주입 (Pouring)  (사출 슬리브·고압 주입 700~1,000 bar)
  (6) 응고 · 이형      (냉각 30~120초·Knockout)
  (7) 트리밍·쇼트블라스트 (런너·게이트 절단·표면 처리)
  (8) 머시닝 (CNC)    (홀·면·나사·정밀 가공)
  (9) 검사 (CT·X-Ray·치수) (기공·균열·치수·표면)
                                  -> 출하
</div>

 <h4>1.3 용해·Spectro 분석</h4>
 <ul>
 <li><strong>유도로 (Induction Furnace)</strong> — 전자기 유도 가열·50~200kHz·자동차 알루미늄 표준</li>
 <li><strong>반사로 (Reverberatory)</strong> — 화염 가열·대용량·에너지 비효율</li>
 <li><strong>전기로 (Electric Resistance)</strong> — 보온·재용해용</li>
 </ul>
 <p>용해 후 <strong>Spectro 분광 분석</strong>으로 18종 원소(Cu·Mg·Si·Fe·Zn·Mn·Ni·Sn·Pb·Cr·Ti 등) 측정. AEC 등급 + OEM 규격 + 합금 표준(예: ADC12 = Al-9.6~12% Si-1.5~3.5% Cu)에 적합한지 검증. NG 시 보정·재용해.</p>

 <h4>1.4 잉곳·리턴 자재·재투입 — 핵심 자재 관리 ★</h4>
 <p>주조 자재는 <strong>신 잉곳(Virgin Ingot)</strong>과 <strong>리턴 자재(Return / Revert)</strong>로 구성된다. 리턴은 트리밍에서 잘려 나온 런너·게이트·스프루·NG 부품을 재용해해서 다시 쓰는 것이다.</p>
 <table>
 <thead><tr><th>자재</th><th>특징</th><th>품질 영향</th></tr></thead>
 <tbody>
 <tr><td>신 잉곳 (Virgin Ingot)</td><td>1차 제련 알루미늄·합금 표준 100%</td><td>고품질·고가</td></tr>
 <tr><td>인하우스 리턴 (In-House Return)</td><td>자기 라인 런너·게이트·NG</td><td>중품질·산화·기공 가능성</td></tr>
 <tr><td>외부 스크랩 (External Scrap)</td><td>외부 회수 알루미늄·구매 스크랩</td><td>저품질·중금속 혼입 위험</td></tr>
 <tr><td>재활용 잉곳 (Secondary Ingot)</td><td>외부 스크랩 2차 제련 잉곳</td><td>중고품질·합금 표준 보장 (인증서)</td></tr>
 </tbody>
 </table>

 <h5>리턴 비율 — OEM CSR 상한</h5>
 <p>리턴 비율 = 리턴 / (신 잉곳 + 리턴) × 100%. OEM CSR이 상한을 명시.</p>
 <table>
 <thead><tr><th>OEM</th><th>리턴 상한</th><th>관리 요구</th></tr></thead>
 <tbody>
 <tr><td>현대·기아 (HKMC)</td><td>30~50% (부품 등급별)</td><td>리턴 lot 추적·월간 보고</td></tr>
 <tr><td>도요타</td><td>30~40%</td><td>15년 lot 보관·OEM 감사</td></tr>
 <tr><td>VW·BMW·Daimler</td><td>20~35%</td><td>Spectro 성분 lot 인증</td></tr>
 <tr><td>안전 핵심 부품 (서스펜션·휠)</td><td>10~20%</td><td>리턴 인하·신 잉곳 우선</td></tr>
 <tr><td>일반 부품 (브래킷·하우징)</td><td>40~60%</td><td>리턴 활용·원가 우선</td></tr>
 </tbody>
 </table>

 <h5>리턴 자재 품질 문제 4종</h5>
 <ol>
 <li><strong>합금 성분 변화</strong> — 재용해 시 Mg·Zn 휘발성 원소 손실·Cu·Fe 누적</li>
 <li><strong>산화 알루미늄(Al2O3) 함량 증가</strong> — 재용해마다 누적·비금속 개재물 증가</li>
 <li><strong>중금속·이물 혼입</strong> — 외부 스크랩 출처·Fe·Pb·Cd</li>
 <li><strong>탈산 부족</strong> — 수소·산소 흡수·가스 기공 발생</li>
 </ol>

 <div class="case">
 <div class="case-title">현장 사례 — 리턴 비율 과다로 X-Ray NG 폭증 (2022)</div>
 <p>국내 모 자동차 부품 협력사. 원가 절감 목표로 리턴 비율을 35% -> 60%로 인상. 1개월 X-Ray 기공 NG율 0.5% -> 4.2%로 8배 폭증. OEM 클레임 12건·SQ 평가 4성 -> 3성 하락 위기. 원인: Spectro 측정만 있고 리턴 비율 자체는 수기 관리. 리턴 lot ↔ 부품 lot 매핑 부재. 6개월 시정 + MES 구축 3억 비용.</p>
 </div>

 <div class="keypoint">
 <div class="keypoint-title">MES가 잡아야 할 데이터 (1) — 잉곳·리턴 자재 관리</div>
 <ul>
 <li>잉곳·리턴·외부 스크랩 lot 단위 입고 추적</li>
 <li>Heat (용해 1회 단위) 별 신/리턴/스크랩 투입 비율 자동 산출</li>
 <li>Heat ↔ 부품 lot 매핑 (Genealogy Forward)</li>
 <li>리턴 lot의 원천 (인하우스·외부) 추적</li>
 <li>OEM CSR 리턴 상한 자동 검증·위반 알람</li>
 <li>15년 lot 보관 — Spectro 성분 + 리턴 비율 동반</li>
 </ul>
 </div>

 <h4>1.5 금형·코어</h4>
 <p>주조 금형은 부품 1종마다 별도 제작. HPDC 8~15만 샷·LPDC 15~30만 샷. 금형 ID·캐비티 ID(1금형 1~8 캐비티)·금형 온도(250~350도)·수명 카운트·수리 이력 모두 MES 관리.</p>

 <h4>1.6 주입·응고·이형 — 공정 파라미터</h4>
 <table>
 <thead><tr><th>파라미터</th><th>범위</th><th>측정</th></tr></thead>
 <tbody>
 <tr><td>용탕 온도</td><td>650~700도 (알루미늄)</td><td>열전대·PLC</td></tr>
 <tr><td>사출 압력 (HPDC)</td><td>700~1,000 bar</td><td>유압 센서·MES 수집</td></tr>
 <tr><td>사출 속도 (1차·2차)</td><td>0.1~5 m/s</td><td>위치 센서·프로파일</td></tr>
 <tr><td>응고 시간</td><td>30~120초</td><td>타이머·자동</td></tr>
 </tbody>
 </table>

 <h4>1.7 후처리·검사</h4>
 <ul>
 <li>트리밍 (런너·게이트 절단 -> 리턴 자재 복귀)</li>
 <li>쇼트블라스트·열처리 (T6 = 솔루션 + 시효)·머시닝(CNC)</li>
 <li>검사 — X-Ray (2D 기공·균열)·CT (3D 안전 부품 100%)·치수(CMM·3D 스캐너)·재료(인장·경도)·표면(LP·MP)</li>
 </ul>

 <h4>1.8 1장 정리 — MES가 잡아야 할 주조 데이터 7가지</h4>
 <div class="keypoint">
 <div class="keypoint-title">MES가 잡아야 할 주조 데이터 7가지 (저자 분류)</div>
 <ol>
 <li>Heat Number 발번·Spectro 성분 18종</li>
 <li>잉곳/리턴/스크랩 lot 단위 투입·리턴 비율</li>
 <li>금형 ID·캐비티 ID·수명 카운트·수리 이력</li>
 <li>주입·응고 공정 조건 (압력·속도·온도·시간)</li>
 <li>후처리 lot — 열처리·표면처리·머시닝</li>
 <li>검사 데이터 — X-Ray·CT·치수·재료</li>
 <li>Genealogy — Heat → 부품 lot → 출하 → VIN</li>
 </ol>
 </div>
</section>

<section id="ch2-wrap">
 <h3 class="chapter" id="ch2">2장 자동차 주조 부품 — 위치·합금·OEM 규격
 <small>주조 부품의 자동차 내 위치·합금 등급·OEM 표준</small>
 </h3>

 <h4>2.1 자동차 주조 부품 — 위치·역할</h4>
 <table>
 <thead><tr><th>부품</th><th>위치·역할</th><th>주조 방식</th><th>합금</th></tr></thead>
 <tbody>
 <tr><td>엔진 블록</td><td>엔진 본체·실린더 수용</td><td>HPDC·사형</td><td>알루미늄 (A356·319)·주철</td></tr>
 <tr><td>실린더 헤드</td><td>엔진 상부·연소실·밸브</td><td>LPDC·중력</td><td>알루미늄 A356·A357</td></tr>
 <tr><td>미션 케이스</td><td>변속기 하우징</td><td>HPDC</td><td>알루미늄 ADC12</td></tr>
 <tr><td>휠 (Alloy Wheel)</td><td>차량 4륜</td><td>LPDC·단조 (고급)</td><td>알루미늄 A356</td></tr>
 <tr><td>서스펜션 암</td><td>현가 시스템·구조 부품</td><td>LPDC·단조</td><td>알루미늄 A356·T6 처리</td></tr>
 <tr><td>브래킷·마운트</td><td>엔진·트랜스·배기 마운트</td><td>HPDC·사형</td><td>알루미늄 ADC12</td></tr>
 <tr><td>하우징·커버</td><td>오일팬·캠샤프트 커버·인테이크</td><td>HPDC·중력</td><td>알루미늄 ADC12</td></tr>
 </tbody>
 </table>

 <h4>2.2 알루미늄 합금 — 자동차 표준 6종</h4>
 <table>
 <thead><tr><th>합금</th><th>표준</th><th>주조 방식</th><th>대표 적용</th></tr></thead>
 <tbody>
 <tr><td>ADC12</td><td>JIS H 5302·KS D 6006</td><td>HPDC</td><td>미션 케이스·구조 부품 (한국·일본 표준)</td></tr>
 <tr><td>A380</td><td>ASTM B85·SAE</td><td>HPDC</td><td>북미 표준</td></tr>
 <tr><td>A356</td><td>ASTM B26·B108</td><td>LPDC·중력</td><td>휠·서스펜션·실린더 헤드</td></tr>
 <tr><td>A357</td><td>ASTM B26</td><td>LPDC</td><td>실린더 헤드 (고강도)</td></tr>
 <tr><td>319</td><td>ASTM B26·B108</td><td>HPDC·중력</td><td>엔진 블록</td></tr>
 <tr><td>AC2B</td><td>JIS H 5202</td><td>중력</td><td>한국·일본 일반 부품</td></tr>
 </tbody>
 </table>

 <h4>2.3 OEM 규격 매핑</h4>
 <ul>
 <li><strong>현대·기아 (HKMC)</strong> — MS (Material Specification) 규격·SQ Mark 5성 평가</li>
 <li><strong>도요타</strong> — TSH (Toyota Standard)·15년 lot 보관</li>
 <li><strong>VW·BMW·Daimler</strong> — VDA·DIN 표준·Formel-Q</li>
 <li><strong>GM</strong> — GMW·CQI-9 (열처리)·CQI-27 (주조 공정)</li>
 <li><strong>Ford</strong> — WSS-M·Q1·QSA (Quality System Assessment)</li>
 </ul>

 <h4>2.4 CQI-27 — AIAG 주조 공정 평가</h4>
 <p>AIAG의 <strong>CQI-27 Special Process: Casting System Assessment</strong>는 주조 공정 협력사가 받는 표준 평가. 12개 영역 (관리·인력·설비·금형·용해·주입·열처리·기계가공·검사·환경·안전·문서) 240개 체크 항목.</p>
 <ul>
 <li>1단계 미충족 시 OEM 거래 위험</li>
 <li>OEM SQE가 협력사 방문해 평가</li>
 <li>MES 데이터가 평가의 직접 증거</li>
 </ul>

 <h4>2.5 2장 정리</h4>
 <div class="keypoint">
 <div class="keypoint-title">자동차 주조 부품 — MES가 잡아야 할 핵심</div>
 <ul>
 <li>부품·합금·OEM 규격 매트릭스 (자재 마스터)</li>
 <li>CQI-27 평가 데이터 자동 추출</li>
 <li>OEM 규격 lot 단위 인증서 매핑 (PPAP)</li>
 </ul>
 </div>
</section>

<section id="ch3-wrap">
 <h3 class="chapter" id="ch3">3장 주조 MES 특수 — 12 데이터 분기·인터록·로트 추적성
 <small>공통편 4장 12 데이터의 주조 분기·주조 특수 인터록 5종·로트 추적성</small>
 </h3>

 <h4>3.1 12가지 데이터 — 주조 분기</h4>
 <p>공통편 4장의 12 데이터 매트릭스를 주조 도메인으로 구체화.</p>
 <table>
 <thead><tr><th>#</th><th>데이터</th><th>주조 구체</th></tr></thead>
 <tbody>
 <tr><td>1</td><td>자재 마스터</td><td>합금 등급·잉곳/리턴 분리·인증서 매핑</td></tr>
 <tr><td>2</td><td>BOM 3단</td><td>부품·금형·합금·리턴 비율</td></tr>
 <tr><td>3</td><td>재활용 비율</td><td>리턴 30~50% OEM CSR 상한·lot 단위 추적</td></tr>
 <tr><td>4</td><td>설비 마스터</td><td>유도로·다이캐스팅·CT·열처리·CNC</td></tr>
 <tr><td>5</td><td>작업자 자격</td><td>주조 작업자·열처리 기사·CT 검사자</td></tr>
 <tr><td>6</td><td>시리얼 발번</td><td>Heat Number + 부품 각인 (레이저·주조)</td></tr>
 <tr><td>7</td><td>공정 조건 수집</td><td>유도로 온도·Spectro·주입 압력·응고 프로파일 (PLC·SCADA 직결)</td></tr>
 <tr><td>8</td><td>인터록 카탈로그</td><td>합금 성분 NG·금형 수명·용탕 온도·리턴 상한·CT NG</td></tr>
 <tr><td>9</td><td>측정·검사 데이터</td><td>Spectro·X-Ray·CT·치수 (CMM·3D 스캐너)·재료</td></tr>
 <tr><td>10</td><td>Genealogy 4단</td><td>완성품 → Heat → 잉곳 → 원자재</td></tr>
 <tr><td>11</td><td>VIN 매핑</td><td>부품 lot → VIN (OEM 측 수신)</td></tr>
 <tr><td>12</td><td>OEM 보고</td><td>PPM·OTD·SPC·PPAP·합금 인증서·리턴 비율 보고</td></tr>
 </tbody>
 </table>

 <h4>3.2 주조 특수 인터록 5종</h4>
 <ol>
 <li><strong>Spectro 성분 NG 자동 격리</strong> — 합금 표준 이탈 시 보온로 차단·재용해</li>
 <li><strong>금형 수명 카운트 차단</strong> — 8~15만 샷 초과 시 자동 정지·금형 교체 트리거</li>
 <li><strong>용탕 온도 한계 알람</strong> — 650~700도 범위 이탈 시 주입 중지</li>
 <li><strong>리턴 비율 상한 차단</strong> — OEM CSR 상한 초과 투입 시 자동 알람·작업자 승인 요구</li>
 <li><strong>CT/X-Ray NG 자동 격리</strong> — 기공·균열 NG 시 후공정 진입 차단·격리 lot 자동 발행</li>
 </ol>

 <h4>3.3 로트 추적성 — 주조 5종 lot</h4>
 <table>
 <thead><tr><th>Lot</th><th>데이터</th><th>보관</th></tr></thead>
 <tbody>
 <tr><td>용탕 lot (Heat No.)</td><td>Spectro 성분 18종·온도·시간·로 번호</td><td>15년</td></tr>
 <tr><td>금형 lot (Mold ID)</td><td>금형 수명 샷 카운트·캐비티 번호·수리 이력</td><td>15년</td></tr>
 <tr><td>응고 lot</td><td>응고 시간·냉각 프로파일·이형 시점</td><td>15년</td></tr>
 <tr><td>후처리 lot</td><td>열처리·표면처리·머시닝 lot</td><td>15년</td></tr>
 <tr><td>검사 lot</td><td>X-Ray·CT·치수·재료 데이터</td><td>15년</td></tr>
 </tbody>
 </table>

 <h4>3.4 Genealogy 4단 — 주조 트리</h4>
 <div class="flow">[주조 Genealogy Backward (완성차 -> 원자재)]

  VIN  (OEM 측)
   ↓
  부품 시리얼 (Heat Number + 캐비티 + 일련번호)
   ↓
  Heat Number  (Spectro 성분·온도·주입 lot)
   ↓
  잉곳·리턴·스크랩 lot  (자재 마스터·인증서)
   ↓
  원자재 lot (1차 제련소·재활용 출처)
</div>
 <p>OEM 클레임 시 VIN 받아 5초 이내 원자재 lot까지 역추적 가능 = OEM 기대 수준.</p>

 <h4>3.5 3장 정리</h4>
 <div class="keypoint">
 <div class="keypoint-title">주조 MES 특수 핵심</div>
 <ul>
 <li>12 데이터 주조 분기·5종 인터록·5 lot 추적성·Genealogy 4단</li>
 <li>리턴 비율 자동 관리 = OEM CSR 충족 핵심</li>
 <li>CT/X-Ray 인터록 = 안전 부품 핵심</li>
 </ul>
 </div>
</section>

<section id="ch4-wrap">
 <h3 class="chapter" id="ch4">4장 주조 MES 시장·통신 표준·14개월 일정
 <small>주조 MES 패키지·PLC/SCADA 통신·14개월 표준 일정·견적</small>
 </h3>

 <h4>4.1 주조 MES 시장 패키지</h4>
 <table>
 <thead><tr><th>벤더</th><th>제품</th><th>특징</th></tr></thead>
 <tbody>
 <tr><td>Siemens</td><td>Opcenter Execution Foundry</td><td>주조 전용·MOM Suite·국제 표준</td></tr>
 <tr><td>iSCMS</td><td>Foundry MES</td><td>유럽 주조 전문</td></tr>
 <tr><td>Yotta</td><td>Yotta MES</td><td>한국 주조 부품 다수</td></tr>
 <tr><td>한국 LS일렉트릭·신한정보시스템·미라콤</td><td>범용 MES + 주조 어댑터</td><td>현대·기아 1차 협력사</td></tr>
 <tr><td>자체 개발</td><td>—</td><td>대형 협력사·OEM 자체 구축</td></tr>
 </tbody>
 </table>

 <h4>4.2 통신 표준 — SCADA·PLC 직결</h4>
 <p>주조 라인은 SMT의 OPC UA·SECS/GEM이나 사출의 Euromap 같은 통일된 통신 표준이 약하다. 설비 벤더별 PLC 직결·SCADA 통신이 표준.</p>
 <ul>
 <li><strong>PLC 직결</strong> — Modbus TCP·EtherNet/IP·Profinet·OPC UA (일부)</li>
 <li><strong>SCADA</strong> — Siemens WinCC·AVEVA System Platform·Wonderware·Rockwell FactoryTalk View</li>
 <li><strong>Spectro 통신</strong> — 벤더별 API (Thermo·Bruker·SPECTRO)</li>
 <li><strong>CT·X-Ray</strong> — 벤더별 API + DICONDE (DICOM for Industrial NDT)</li>
 </ul>

 <h4>4.3 14개월 표준 일정</h4>
 <p>공통편 8장 6 게이트와 동일. 단계별 표준 MM은 공통편 6장 6.4 (71 MM)과 비교해 주조 특수:</p>
 <ul>
 <li>5부 구축 (인터페이스) — +3~5 MM (벤더별 어댑터 다수)</li>
 <li>6부 테스트 (CT/X-Ray UAT) — +2 MM (안전 부품 100% 검사 시나리오)</li>
 <li>합계 주조 표준 ~76~78 MM</li>
 </ul>

 <h4>4.4 견적·라인 수별 표준 단가 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 산정 - 2026 한국 시장)</em></h4>
 <table>
 <thead><tr><th>규모</th><th>라인 수</th><th>표준 견적 (억)</th><th>특이</th></tr></thead>
 <tbody>
 <tr><td>소</td><td>1~2 라인 + 후공정</td><td>6~10</td><td>중소 협력사·MVP 위주</td></tr>
 <tr><td>중</td><td>3~5 라인 + 열처리·CNC</td><td>12~20</td><td>표준 협력사·전체 영역</td></tr>
 <tr><td>대</td><td>6~10 라인 + 2차 공정 (조립·검사)</td><td>22~35</td><td>1차 협력사·OEM 직접 납품</td></tr>
 </tbody>
 </table>

 <h4>4.5 1부 정리 — 주조편 다음 단계</h4>
 <div class="side">
 <div class="side-title">주조편 1부 마무리</div>
 <p>1부는 주조 도메인 특수. 2부부터는 공통편과 동일한 영업·진단·설계·구축·테스트·컷오버·Hyper Care 단계. 자동차 부품 공통 품질 체계(IATF·SQ·APQP·PPAP·FMEA·VIN)·BOM 3단·MES MESA·12 데이터 매트릭스는 공통편 1부 참조.</p>
 </div>
</section>
'@

$newContent = $content.Substring(0, $startIdx) + $casting + "`r`n`r`n" + $content.Substring($endIdx)
[System.IO.File]::WriteAllText($file_c, $newContent, $utf8NoBom)
Write-Host "casting done"

# ===========================================
# 사출편
# ===========================================
$file_i = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($file_i, [System.Text.Encoding]::UTF8)
$startIdx = $content.IndexOf('<section id="ch1-wrap">')
$endIdx = $content.IndexOf($marker)
if ($startIdx -lt 0 -or $endIdx -lt 0) { Write-Host "injection marker not found ($startIdx, $endIdx)"; exit 1 }

$injection = @'
<section id="ch1-wrap">
 <h3 class="chapter" id="ch1">1장 사출 공정 — 사출부터 후공정까지
 <small>사출 본질·자동차 사출 부품·공정 흐름·MES가 잡아야 할 데이터</small>
 </h3>

 <p>사출(Injection Molding)은 플라스틱 원료를 가열·용융시켜 금형에 고압으로 주입한 뒤 냉각·이형해 부품을 만드는 공정이다. 자동차 산업에서 인테리어(대시보드·도어트림·콘솔)·익스테리어(범퍼·라디에이터 그릴·헤드램프 렌즈)·전장 하우징(블랙박스 케이스·ECU 케이스·커넥터·하네스 클립)·시트 부품 등 차량의 외형과 사용자 접점의 절대 다수가 사출로 만들어진다.</p>

 <h4>1.1 사출 공정 사이클 — 6단계</h4>
 <div class="flow">[사출 1 사이클 — 6단계 (15~120초)]

  (1) 원료 건조       (호퍼·드라이어·습도 0.02% 이하)
  (2) 가소화·계량     (스크류 회전·원료 용융 200~280도)
  (3) 사출 (Injection) (1차·2차·3차 사출 - 압력 800~2,000 bar)
  (4) 보압 (Holding)   (응고 압력 유지·치수 안정)
  (5) 냉각 (Cooling)   (금형 냉각·응고 - 사이클의 60~80%)
  (6) 이형 (Ejection)  (금형 열림·로봇 인출)
                          -> 후공정
</div>

 <h4>1.2 사출기 4분류</h4>
 <table>
 <thead><tr><th>형태</th><th>형체력</th><th>대표 용도</th></tr></thead>
 <tbody>
 <tr><td>수평형 사출기</td><td>50~6,000 톤</td><td>자동차 부품 대다수 (범퍼·대시·하우징)</td></tr>
 <tr><td>수직형 사출기</td><td>20~500 톤</td><td>인서트 사출·소형 부품</td></tr>
 <tr><td>전동식 (All-Electric)</td><td>50~500 톤</td><td>정밀·반복성·청정 부품·렌즈</td></tr>
 <tr><td>유압식 (Hydraulic)</td><td>500~6,000 톤</td><td>대형 부품·범퍼·대시보드</td></tr>
 <tr><td>하이브리드</td><td>—</td><td>전동+유압 혼합·중대형 부품</td></tr>
 </tbody>
 </table>

 <h4>1.3 자동차 사출 부품 — 위치·역할</h4>
 <table>
 <thead><tr><th>부품</th><th>위치</th><th>레진</th><th>특이</th></tr></thead>
 <tbody>
 <tr><td>범퍼 (Bumper)</td><td>차량 전·후면</td><td>PP/EPDM·TPO</td><td>UV·내충격·도색</td></tr>
 <tr><td>대시보드 (Instrument Panel)</td><td>운전석 내부</td><td>ABS·PP·PC/ABS</td><td>다중 사출·인서트·표면 처리</td></tr>
 <tr><td>도어 트림</td><td>도어 내부</td><td>PP·ABS·PVC</td><td>표피 본딩·이중 사출</td></tr>
 <tr><td>램프 렌즈 (Headlamp Lens)</td><td>전조등·후미등</td><td>PC (Polycarbonate)·PMMA</td><td>광학·코팅 (UV·하드)</td></tr>
 <tr><td>블랙박스 하우징</td><td>윈드실드 부착</td><td>ABS·PC/ABS·UV 안정화</td><td>UV·내열·전자파 차폐</td></tr>
 <tr><td>ECU 케이스</td><td>엔진룸·계기판</td><td>PA66·PBT (글라스 강화)</td><td>내열 (Grade 1)·진동</td></tr>
 <tr><td>커넥터·하네스 클립</td><td>전체 차량 (수백 개)</td><td>PA66·PBT</td><td>치수 정밀·내열</td></tr>
 <tr><td>그릴 (Radiator Grille)</td><td>전면</td><td>ABS·PC/ABS</td><td>크롬 도금 후공정</td></tr>
 </tbody>
 </table>

 <h4>1.4 레진·Regrind — 핵심 자재 관리 ★</h4>
 <p>사출 자재는 <strong>신원료(Virgin Resin)</strong>와 <strong>Regrind(재투입 원료)</strong>로 구성된다. Regrind는 스프루·런너·NG 부품을 분쇄해 신원료에 섞어 다시 쓰는 것. 주조의 리턴과 같은 개념이다.</p>
 <table>
 <thead><tr><th>자재</th><th>특징</th><th>품질 영향</th></tr></thead>
 <tbody>
 <tr><td>신원료 (Virgin Resin)</td><td>1차 제조 펠릿·물성 100% 충족</td><td>고품질·고가</td></tr>
 <tr><td>인하우스 Regrind</td><td>자기 라인 스프루·런너·NG 분쇄</td><td>중품질·열 이력 누적</td></tr>
 <tr><td>외부 재활용 (Post-Industrial)</td><td>외부 회수·구매 분쇄품</td><td>저품질·물성 변동</td></tr>
 <tr><td>PCR (Post-Consumer Recycled)</td><td>소비자 회수 재활용</td><td>EU·OEM ESG 요구 자재</td></tr>
 </tbody>
 </table>

 <h5>Regrind 비율 — OEM CSR 상한</h5>
 <p>Regrind 비율 = Regrind / (신원료 + Regrind) × 100%. 비율이 높을수록 원가 절감이지만 분자 사슬 절단·물성 저하·NG 위험. OEM CSR이 상한을 명시.</p>
 <table>
 <thead><tr><th>OEM·부품</th><th>Regrind 상한</th><th>관리 요구</th></tr></thead>
 <tbody>
 <tr><td>안전 부품 (에어백 커버·시트 구조)</td><td>0% (신원료만)</td><td>PPAP Level 3</td></tr>
 <tr><td>광학 부품 (램프 렌즈)</td><td>0~5%</td><td>광학 물성 검증</td></tr>
 <tr><td>외장 (범퍼·그릴 표면)</td><td>10~20%</td><td>색상·표면 외관</td></tr>
 <tr><td>내장 (대시·도어 트림)</td><td>20~30%</td><td>물성 검증</td></tr>
 <tr><td>비표면·내부 부품</td><td>30~50%</td><td>물성 모니터링</td></tr>
 <tr><td>EU 차량 (ELV Directive)</td><td>PCR ≥25% (2030년부터)</td><td>PCR 비율 보고</td></tr>
 </tbody>
 </table>

 <h5>Regrind 품질 문제 5종</h5>
 <ol>
 <li><strong>열 이력 누적</strong> — 분자 사슬 절단·물성(인장 강도·충격) 저하</li>
 <li><strong>색상 변화·황변</strong> — 재가열로 색 변화. 외장·광학 부품 치명적</li>
 <li><strong>흡습·기포</strong> — 분쇄 시 표면적 증가·습도 흡수. 사출 시 기포 발생</li>
 <li><strong>오염·이물 혼입</strong> — 분쇄 공정 오염·다른 레진 혼입 위험</li>
 <li><strong>점도 변화</strong> — 사출 사이클·성형성 영향</li>
 </ol>

 <div class="case">
 <div class="case-title">현장 사례 — Regrind 비율 과다로 광학 부품 NG (2023)</div>
 <p>국내 모 자동차 부품 협력사. 헤드램프 렌즈(PC) 양산. 원가 절감 목표로 Regrind 비율 0% -> 8%로 인상. 1개월 후 OEM 측 광학 검사에서 황변·MTF 저하 NG율 0.2% -> 3.5% 폭증. OEM 클레임 8건·SQ 4성 -> 3성 하락. 원인: 라인에서 Regrind 비율 수기 관리·Shot 단위 추적 없음. 8주 시정 + MES 구축 (Regrind lot 단위 추적·Shot 자동 매핑) + 4억 비용.</p>
 </div>

 <div class="keypoint">
 <div class="keypoint-title">MES가 잡아야 할 데이터 (1) — 레진·Regrind 관리</div>
 <ul>
 <li>레진·Regrind·PCR lot 단위 입고 추적·인증서 매핑</li>
 <li>Shot (사출 1회 단위)별 신/Regrind/PCR 투입 비율 자동 산출</li>
 <li>Shot ↔ 부품 lot 매핑 (캐비티별 분리)</li>
 <li>Regrind 원천 (인하우스·외부) 추적</li>
 <li>OEM CSR Regrind 상한 자동 검증·위반 알람</li>
 <li>EU ELV PCR ≥25% 자동 보고</li>
 <li>15년 lot 보관 — 사출 조건 + Regrind 비율 동반</li>
 </ul>
 </div>

 <h4>1.5 금형·캐비티·Hot Runner</h4>
 <ul>
 <li><strong>금형 ID·캐비티 ID</strong> — 1금형 4~32 캐비티. 1샷 N개 동시 성형. 캐비티별 NG 추적</li>
 <li><strong>Hot Runner</strong> — 금형 내 용융 레진 유로. 6~32 zone 온도 제어. zone별 온도 프로파일 수집</li>
 <li><strong>금형 수명</strong> — 100~500만 샷. 수리·교체 이력 PPAP 직결</li>
 <li><strong>금형 온도</strong> — 30~120도 (레진별). 유지 시 치수 안정</li>
 </ul>

 <h4>1.6 사출 공정 파라미터</h4>
 <table>
 <thead><tr><th>파라미터</th><th>범위</th><th>측정</th></tr></thead>
 <tbody>
 <tr><td>사출 압력 (1차·2차)</td><td>800~2,000 bar</td><td>유압 센서·실시간</td></tr>
 <tr><td>사출 속도 (1~5단)</td><td>10~500 mm/s</td><td>위치 센서·프로파일</td></tr>
 <tr><td>보압</td><td>50~80% 사출압</td><td>유압 센서</td></tr>
 <tr><td>가소화 온도</td><td>200~280도 (레진별)</td><td>열전대 zone별</td></tr>
 <tr><td>금형 온도</td><td>30~120도</td><td>금형 내부 열전대</td></tr>
 <tr><td>사이클 시간</td><td>15~120초</td><td>자동 카운트</td></tr>
 </tbody>
 </table>

 <h4>1.7 후공정 — 도색·인쇄·증착·접합</h4>
 <ul>
 <li>도색 (Painting) — 범퍼·외장 부품 (수성·솔벤트·UV 경화)</li>
 <li>인쇄 (Pad Printing·Tampography) — 로고·표시</li>
 <li>증착 (Vacuum Metallization·Sputtering) — 그릴 크롬·내장 부품 광택</li>
 <li>접합 (Ultrasonic Welding·Hot Plate·Vibration) — 다중 부품 결합</li>
 </ul>

 <h4>1.8 검사 — 치수·외관·기능</h4>
 <table>
 <thead><tr><th>검사</th><th>대상</th><th>NG 기준</th></tr></thead>
 <tbody>
 <tr><td>치수 (CMM·3D 스캐너·Gauge)</td><td>외형·홀·평면도</td><td>도면 ±공차</td></tr>
 <tr><td>외관 (자동 비전·수동)</td><td>표면·플로우 마크·싱크·버</td><td>OEM 외관 표준</td></tr>
 <tr><td>광학 (램프 렌즈)</td><td>MTF·왜곡·투과율</td><td>OEM 광학 표준</td></tr>
 <tr><td>기능 (도전성·전자파 차폐·내열)</td><td>전장 하우징</td><td>OEM 기능 시험</td></tr>
 <tr><td>물성 (인장·충격·열변형)</td><td>샘플링 lot당</td><td>OEM 물성 표준</td></tr>
 </tbody>
 </table>

 <h4>1.9 1장 정리 — MES가 잡아야 할 사출 데이터 7가지</h4>
 <div class="keypoint">
 <div class="keypoint-title">MES가 잡아야 할 사출 데이터 7가지 (저자 분류)</div>
 <ol>
 <li>Shot Number + Cavity ID 발번·캐비티별 분리 추적</li>
 <li>신원료/Regrind/PCR lot 단위 투입·비율</li>
 <li>금형 ID·캐비티·수명 카운트·Hot Runner zone 온도</li>
 <li>사출 공정 조건 (압력·보압·속도·온도·사이클)</li>
 <li>후공정 lot — 도색·인쇄·증착·접합</li>
 <li>검사 데이터 — 치수·외관·광학·기능·물성</li>
 <li>Genealogy — Shot → 캐비티 → 부품 lot → 출하 → VIN</li>
 </ol>
 </div>
</section>

<section id="ch2-wrap">
 <h3 class="chapter" id="ch2">2장 자동차 사출 레진·OEM 규격
 <small>레진 종류·OEM 규격·EU ELV·PCR</small>
 </h3>

 <h4>2.1 자동차 사출 레진 10종</h4>
 <table>
 <thead><tr><th>레진</th><th>특징</th><th>대표 적용</th></tr></thead>
 <tbody>
 <tr><td>PP (Polypropylene)</td><td>저가·내약품·중강도</td><td>범퍼·도어트림·일반 부품</td></tr>
 <tr><td>ABS</td><td>충격·표면 가공·도색 적합</td><td>대시·도어트림·외장</td></tr>
 <tr><td>PC (Polycarbonate)</td><td>광학·내충격·내열</td><td>램프 렌즈·블랙박스 하우징</td></tr>
 <tr><td>PC/ABS</td><td>PC + ABS 블렌드·내열+가공성</td><td>전장 하우징·내장 부품</td></tr>
 <tr><td>PA6·PA66 (Nylon)</td><td>고강도·내열·내약품</td><td>커넥터·하네스 클립·엔진룸</td></tr>
 <tr><td>PBT</td><td>내열·치수 안정</td><td>ECU 케이스·전기 부품</td></tr>
 <tr><td>POM (Acetal)</td><td>마찰·치수 정밀</td><td>기어·슬라이드 부품</td></tr>
 <tr><td>TPE·TPO</td><td>탄성·시일</td><td>가스켓·표피·범퍼 시일</td></tr>
 <tr><td>PMMA (Acrylic)</td><td>광학·UV 안정</td><td>램프 렌즈 (일부)</td></tr>
 <tr><td>PPS</td><td>고내열 (200도+)·고강도</td><td>고온 엔진 부품</td></tr>
 </tbody>
 </table>

 <h4>2.2 OEM 규격 매핑</h4>
 <ul>
 <li><strong>현대·기아 (HKMC)</strong> — MS·SQ Mark 5성</li>
 <li><strong>도요타</strong> — TSH·15년 lot 보관</li>
 <li><strong>VW·BMW·Daimler</strong> — VDA·DIN·Formel-Q·TL (재료 표준)</li>
 <li><strong>GM</strong> — GMW·CQI-23 (사출 공정 평가)</li>
 <li><strong>Ford</strong> — WSS-M·Q1</li>
 </ul>

 <h4>2.3 CQI-23 — AIAG 사출 공정 평가</h4>
 <p>AIAG의 <strong>CQI-23 Special Process: Molding System Assessment</strong>는 사출 공정 협력사 표준 평가. 사출기·금형·재료·공정 조건·후공정·검사 6영역 200+ 체크. CQI-23 평가 데이터가 MES 직접 산출 영역.</p>

 <h4>2.4 EU ELV·PCR — 2030 의무</h4>
 <p>EU End-of-Life Vehicles Directive 2024 개정 — <strong>2030년부터 차량 1대 PCR 비율 ≥25% 의무</strong>. 협력사가 부품 단위 PCR 비율 보고 의무. MES가 lot 단위 PCR 자동 집계·OEM 송신 필수.</p>

 <h4>2.5 2장 정리</h4>
 <div class="keypoint">
 <div class="keypoint-title">사출 레진·OEM 핵심</div>
 <ul>
 <li>레진 10종·OEM 규격·CQI-23 매트릭스</li>
 <li>EU ELV PCR ≥25% 자동 보고 (2030)</li>
 <li>레진 lot ↔ Shot ↔ 부품 lot 4단 매핑</li>
 </ul>
 </div>
</section>

<section id="ch3-wrap">
 <h3 class="chapter" id="ch3">3장 사출 MES 특수 — 12 데이터 분기·인터록·로트 추적성
 <small>공통편 4장 12 데이터의 사출 분기·사출 특수 인터록 6종·Shot 단위 추적성</small>
 </h3>

 <h4>3.1 12가지 데이터 — 사출 분기</h4>
 <table>
 <thead><tr><th>#</th><th>데이터</th><th>사출 구체</th></tr></thead>
 <tbody>
 <tr><td>1</td><td>자재 마스터</td><td>레진 등급·Regrind/PCR 분리·인증서·UV 안정제</td></tr>
 <tr><td>2</td><td>BOM 3단</td><td>부품·금형·캐비티·레진·Regrind 비율</td></tr>
 <tr><td>3</td><td>재활용 비율</td><td>Regrind 20~30%·PCR 25%·OEM CSR 상한 Shot 단위 추적</td></tr>
 <tr><td>4</td><td>설비 마스터</td><td>사출기·Hot Runner·금형·로봇·후공정</td></tr>
 <tr><td>5</td><td>작업자 자격</td><td>사출 작업자·금형 보전·도색 기사</td></tr>
 <tr><td>6</td><td>시리얼 발번</td><td>Shot Number + Cavity ID (1샷 N개 분리)</td></tr>
 <tr><td>7</td><td>공정 조건 수집</td><td>Euromap 77 (OPC UA Companion)·Euromap 63·사출 사이클·Hot Runner 온도</td></tr>
 <tr><td>8</td><td>인터록 카탈로그</td><td>사출 압력 ±%·캐비티 NG 3샷·금형 수명·온도·Regrind 상한·습도</td></tr>
 <tr><td>9</td><td>측정·검사 데이터</td><td>치수·외관·광학·기능·물성</td></tr>
 <tr><td>10</td><td>Genealogy 4단</td><td>완성품 → Shot → 레진 → Regrind</td></tr>
 <tr><td>11</td><td>VIN 매핑</td><td>부품 lot → VIN (OEM)</td></tr>
 <tr><td>12</td><td>OEM 보고</td><td>PPM·OTD·SPC·PPAP·Regrind/PCR 비율·CQI-23·EU ELV</td></tr>
 </tbody>
 </table>

 <h4>3.2 사출 특수 인터록 6종</h4>
 <ol>
 <li><strong>사출 압력 ±% 차단</strong> — 표준 압력 ±5% 이탈 시 자동 정지·격리</li>
 <li><strong>캐비티 NG 연속 차단</strong> — 한 캐비티 NG 3샷 연속 시 그 캐비티 자동 차단·금형 수리 트리거</li>
 <li><strong>금형 수명 카운트 차단</strong> — 100~500만 샷 초과 시 자동 정지</li>
 <li><strong>금형/Hot Runner 온도 한계 알람</strong> — 범위 이탈 시 사출 중지</li>
 <li><strong>Regrind/PCR 비율 상한 차단</strong> — OEM CSR 상한 초과 투입 시 자동 알람·승인 요구</li>
 <li><strong>건조 습도 차단</strong> — 호퍼 습도 0.02% 초과 시 사출 차단 (PA·PC 핵심)</li>
 </ol>

 <h4>3.3 로트 추적성 — 사출 5종 lot</h4>
 <table>
 <thead><tr><th>Lot</th><th>데이터</th><th>보관</th></tr></thead>
 <tbody>
 <tr><td>원료 lot</td><td>Resin Lot No.·Regrind 비율·PCR 비율·건조 시간·습도</td><td>15년</td></tr>
 <tr><td>사출 lot (Shot)</td><td>사출 압력·보압·속도·온도·사이클 (샷 단위)</td><td>15년</td></tr>
 <tr><td>캐비티 lot (Cavity ID)</td><td>1샷 N개 중 캐비티별 분리·Hot Runner zone 온도</td><td>15년</td></tr>
 <tr><td>후공정 lot</td><td>도색·인쇄·증착·접합 lot</td><td>15년</td></tr>
 <tr><td>검사 lot</td><td>치수·외관·광학·기능·물성</td><td>15년</td></tr>
 </tbody>
 </table>

 <h4>3.4 Shot 단위 데이터 양 — 사출의 핵심 부담</h4>
 <p>사출은 도메인 중 데이터 양이 가장 크다. 사이클 30초·24시간·1샷 50필드 = 약 14만 레코드/일/기계. 10기 = 140만/일. 5년 누적 25억+. 핫/웜/콜드 아키텍처 무게가 사출편에서 가장 크다 (공통편 16장 16.5 참조).</p>

 <h4>3.5 Genealogy 4단 — 사출 트리</h4>
 <div class="flow">[사출 Genealogy Backward (완성차 -> 원료)]

  VIN  (OEM 측)
   ↓
  부품 시리얼 (Shot + Cavity + 일련번호)
   ↓
  Shot Number  (사출 압력·온도·사이클·캐비티 ID·Hot Runner zone 온도)
   ↓
  원료 lot  (Resin Lot + Regrind 비율 + PCR 비율 + 건조 이력)
   ↓
  원자재 lot (1차 제조 펠릿·재활용 출처)
</div>

 <h4>3.6 3장 정리</h4>
 <div class="keypoint">
 <div class="keypoint-title">사출 MES 특수 핵심</div>
 <ul>
 <li>12 데이터 사출 분기·6종 인터록·Shot 단위 추적·캐비티 분리</li>
 <li>Regrind/PCR 비율 자동 관리 = OEM CSR + EU ELV 충족</li>
 <li>데이터 양 압도적 — 핫/웜/콜드 아키텍처 핵심</li>
 </ul>
 </div>
</section>

<section id="ch4-wrap">
 <h3 class="chapter" id="ch4">4장 사출 MES 시장·통신 표준·14개월 일정
 <small>사출 MES 패키지·Euromap 77/63·14개월 표준 일정·견적</small>
 </h3>

 <h4>4.1 사출 MES 시장 패키지</h4>
 <table>
 <thead><tr><th>벤더</th><th>제품</th><th>특징</th></tr></thead>
 <tbody>
 <tr><td>Engel</td><td>e-factory</td><td>Engel 사출기 직접·자동차 부품 강세</td></tr>
 <tr><td>Arburg</td><td>arburgXworld</td><td>Arburg 사출기·정밀 부품</td></tr>
 <tr><td>KraussMaffei</td><td>netstal·KraussMaffei Connect</td><td>대형 부품·자동차 외장</td></tr>
 <tr><td>Siemens</td><td>Opcenter Execution</td><td>범용 + Euromap 어댑터</td></tr>
 <tr><td>한국 LS일렉트릭·신한·미라콤</td><td>범용 MES + 사출 어댑터</td><td>현대·기아 1차 협력사</td></tr>
 <tr><td>자체 개발</td><td>—</td><td>대형 협력사</td></tr>
 </tbody>
 </table>

 <h4>4.2 통신 표준 — Euromap 77·63 핵심</h4>
 <p>사출은 SMT의 OPC UA·주조의 PLC 직결과 달리 통일된 통신 표준이 잘 정착됐다.</p>
 <ul>
 <li><strong>Euromap 77 (OPC UA Companion Spec for Injection Molding)</strong> — OPC UA 기반 사출기 통신 표준·2018년 발행·전 신규 사출기 표준</li>
 <li><strong>Euromap 63</strong> — XML/파일 기반 구형 사출기 통신·2000년대 표준·아직 다수 사출기에 적용</li>
 <li><strong>Hot Runner 통신</strong> — 벤더별 API (Mold-Masters·Husky·INCOE)</li>
 <li><strong>로봇 통신</strong> — Euromap 67 (사출기 ↔ 로봇 인터페이스)</li>
 </ul>

 <h4>4.3 Euromap 77 데이터 표준</h4>
 <p>Euromap 77이 표준화한 사출기 데이터 약 300+ 변수. 핵심:</p>
 <ul>
 <li>기계 상태 (가동·정지·알람)</li>
 <li>사이클별 사출 압력·보압·속도·시간 곡선</li>
 <li>Shot 카운트·NG 카운트·OEE</li>
 <li>온도 zone별 측정값</li>
 <li>금형·재료·작업자 마스터</li>
 </ul>

 <h4>4.4 14개월 표준 일정</h4>
 <p>공통편 8장 6 게이트와 동일. 사출 특수:</p>
 <ul>
 <li>5부 구축 (Euromap 77 어댑터) — +2~3 MM (OPC UA Companion 표준 활용)</li>
 <li>6부 테스트 (Shot 단위 추적 UAT) — +2 MM (데이터 양 검증)</li>
 <li>합계 사출 표준 ~74~76 MM</li>
 </ul>

 <h4>4.5 견적·라인 수별 표준 단가 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 산정 - 2026 한국 시장)</em></h4>
 <table>
 <thead><tr><th>규모</th><th>사출기 수</th><th>표준 견적 (억)</th><th>특이</th></tr></thead>
 <tbody>
 <tr><td>소</td><td>1~5 기 + 후공정</td><td>5~9</td><td>중소 협력사·MVP</td></tr>
 <tr><td>중</td><td>6~15 기 + 도색·조립</td><td>10~18</td><td>표준 협력사</td></tr>
 <tr><td>대</td><td>16~40 기 + 다중 후공정·100% Shot 추적</td><td>20~38</td><td>1차 협력사·OEM 직납</td></tr>
 </tbody>
 </table>
 <p>대규모 사출 협력사의 견적이 SMT·주조보다 약간 높은 경향 — 데이터 양·핫/웜/콜드 아키텍처 부담.</p>

 <h4>4.6 1부 정리 — 사출편 다음 단계</h4>
 <div class="side">
 <div class="side-title">사출편 1부 마무리</div>
 <p>1부는 사출 도메인 특수. 2부부터는 공통편과 동일. 자동차 부품 공통 품질 체계(IATF·SQ·APQP·PPAP·FMEA·VIN)·BOM 3단·MES MESA·12 데이터 매트릭스는 공통편 1부 참조.</p>
 </div>
</section>
'@

$newContent = $content.Substring(0, $startIdx) + $injection + "`r`n`r`n" + $content.Substring($endIdx)
[System.IO.File]::WriteAllText($file_i, $newContent, $utf8NoBom)
Write-Host "injection done"
Write-Host "All done"
