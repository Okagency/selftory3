[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

$casting_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($casting_file, [System.Text.Encoding]::UTF8)

# 주조편 1장 심화 sub-section — 1.8 (1장 정리 keypoint) 직전에 추가
$ch1_deep = @'

 <hr class="scene">

 <h4>1.8.1 주조 5종 방식 상세 매트릭스 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table class="nowrap-table">
 <thead><tr><th>방식</th><th>압력</th><th>온도</th><th>금형</th><th>생산성</th><th>표면조도 Ra</th><th>치수정밀도 IT</th><th>설비비</th><th>OEM 적용</th></tr></thead>
 <tbody>
 <tr><td>사형 (Sand)</td><td>중력</td><td>660~720도</td><td>모래</td><td>5~30/h</td><td>12~25μm</td><td>IT 14~16</td><td>저</td><td>엔진 블록·미션 케이스·대형 브래킷</td></tr>
 <tr><td>중력 다이</td><td>중력</td><td>660~720도</td><td>금속</td><td>30~80/h</td><td>3~6μm</td><td>IT 11~13</td><td>중</td><td>실린더 헤드·휠 일부</td></tr>
 <tr><td>저압 다이 (LPDC)</td><td>0.3~1 bar</td><td>660~720도</td><td>금속·다단</td><td>50~120/h</td><td>1.6~3μm</td><td>IT 10~12</td><td>중고</td><td>알로이 휠·서스펜션 암</td></tr>
 <tr><td>고압 다이 (HPDC)</td><td>700~1,000 bar</td><td>650~720도</td><td>금속·고온</td><td>50~200/h</td><td>0.8~3μm</td><td>IT 9~11</td><td>고</td><td>미션 케이스·구조 부품</td></tr>
 <tr><td>로스트왁스</td><td>중력</td><td>1,400~1,600도</td><td>세라믹</td><td>2~10/h</td><td>0.8~2μm</td><td>IT 8~10</td><td>최고</td><td>터빈 블레이드·정밀</td></tr>
 </tbody>
 </table>

 <h4>1.8.2 용해로 5종 — 자동차 주조 적용 상세</h4>
 <table>
 <thead><tr><th>용해로</th><th>원리</th><th>용량</th><th>장점</th><th>단점·자동차 적용</th></tr></thead>
 <tbody>
 <tr><td>유도로 (코어리스)</td><td>전자기 유도·50~200kHz</td><td>50kg~30t</td><td>청정·정밀·자동화·CO2 적음</td><td>전력비·고가. 알루미늄 자동차 표준</td></tr>
 <tr><td>유도로 (채널형·Channel)</td><td>철심 + 1차 코일·저주파</td><td>1~50t</td><td>대용량·연속·에너지 효율</td><td>보온·재용해용. 자동차 보온로 표준</td></tr>
 <tr><td>가스 반사로</td><td>천연가스·중유 화염</td><td>1~20t</td><td>저비용·대용량</td><td>오염·CO2·에너지 비효율. 구식</td></tr>
 <tr><td>전기 저항로</td><td>저항 발열체</td><td>50kg~5t</td><td>온도 정밀·구조 단순</td><td>저용량·보온용. 일부 자동차</td></tr>
 <tr><td>플라즈마로</td><td>플라즈마 토치</td><td>1~10t</td><td>고온·특수 합금</td><td>고비용·특수. 항공·고급 합금</td></tr>
 </tbody>
 </table>

 <h4>1.8.3 금형 5종 — 자동차 주조 적용</h4>
 <table>
 <thead><tr><th>금형</th><th>재료</th><th>수명 (샷)</th><th>비용</th><th>자동차 적용</th></tr></thead>
 <tbody>
 <tr><td>사형 (Green Sand)</td><td>벤토나이트 + 모래 + 물</td><td>1회</td><td>저</td><td>엔진 블록·대형 부품</td></tr>
 <tr><td>쉘 몰드 (Shell Mold)</td><td>레진 코팅 모래</td><td>1회</td><td>중</td><td>정밀 사형</td></tr>
 <tr><td>중력 다이 (Permanent)</td><td>주철·강·구리</td><td>50~200,000</td><td>중고</td><td>실린더 헤드·휠</td></tr>
 <tr><td>HPDC 다이 (Hot Work)</td><td>H13·SKD61·합금강</td><td>80,000~500,000</td><td>고</td><td>HPDC 표준</td></tr>
 <tr><td>코어 박스 (Sand Core)</td><td>금속·레진 모래</td><td>1회/N회</td><td>중</td><td>엔진 내부 워터재킷</td></tr>
 </tbody>
 </table>

 <h4>1.8.4 후처리 7종</h4>
 <table>
 <thead><tr><th>후처리</th><th>목적</th><th>설비</th></tr></thead>
 <tbody>
 <tr><td>트리밍 (Trimming)</td><td>런너·게이트 절단 → 리턴 자재 복귀</td><td>유압 프레스·트림 다이</td></tr>
 <tr><td>쇼트블라스트 (Shot Blast)</td><td>표면 세정·산화 제거</td><td>스틸·세라믹 쇼트</td></tr>
 <tr><td>열처리 (Heat Treat)</td><td>T6 = Solution Treat + Aging·강도 향상</td><td>가스로·전기로·진공로</td></tr>
 <tr><td>표면처리 (Surface)</td><td>아노다이징·도금·페인팅·CR</td><td>전해조·도금 라인</td></tr>
 <tr><td>머시닝 (CNC)</td><td>홀·면·나사·정밀 가공</td><td>3·4·5축 머시닝 센터</td></tr>
 <tr><td>접합 (Welding·Adhesive)</td><td>다중 부품 결합</td><td>MIG/TIG·레이저·접착</td></tr>
 <tr><td>조립·시험</td><td>완제품 조립·기능 시험</td><td>조립 라인·테스트 베드</td></tr>
 </tbody>
 </table>

 <h4>1.8.5 검사 8종 — NDT 표준</h4>
 <table>
 <thead><tr><th>검사</th><th>표준</th><th>적용</th><th>NG 기준</th></tr></thead>
 <tbody>
 <tr><td>X-Ray (2D RT)</td><td>ASTM E155·ISO 19232</td><td>기공·균열·이물</td><td>OEM별 직경 0.3~0.5mm+</td></tr>
 <tr><td>CT (3D Computed Tomography)</td><td>ASTM E1570</td><td>안전 부품 100%</td><td>3D 내부 결함 자동</td></tr>
 <tr><td>CMM (Coordinate Measuring)</td><td>ISO 10360</td><td>치수·평면도·동축도</td><td>도면 ±공차</td></tr>
 <tr><td>3D 스캐너 (Optical)</td><td>VDI 2634</td><td>표면 형상·역설계</td><td>설계 CAD 비교</td></tr>
 <tr><td>LP (Liquid Penetrant)</td><td>ASTM E165</td><td>표면 균열·기공</td><td>OEM별</td></tr>
 <tr><td>MT (Magnetic Particle)</td><td>ASTM E709</td><td>강자성 부품 표면</td><td>주철 부품 위주</td></tr>
 <tr><td>UT (Ultrasonic)</td><td>ASTM E114</td><td>내부 균열·라미네이션</td><td>두꺼운 부품</td></tr>
 <tr><td>인장·경도·충격</td><td>ASTM E8·E10·E23</td><td>샘플링 lot당 N개</td><td>합금 표준 + OEM 규격</td></tr>
 </tbody>
 </table>

 <h4>1.8.6 주조 결함 12종 — Pareto 패턴 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 분류)</em></h4>
 <table>
 <thead><tr><th>결함</th><th>원인</th><th>MES 인터록</th></tr></thead>
 <tbody>
 <tr><td>가스 기공 (Gas Porosity)</td><td>용탕 가스 흡수·습기·유속</td><td>온도·압력·시간 SPC</td></tr>
 <tr><td>수축공 (Shrinkage Porosity)</td><td>응고 시 부피 수축</td><td>응고 시간 SPC·금형 온도</td></tr>
 <tr><td>콜드 셧 (Cold Shut)</td><td>주입 속도·온도 부족</td><td>주입 속도 인터록</td></tr>
 <tr><td>미스런 (Misrun)</td><td>금형 채움 부족</td><td>주입 압력·온도</td></tr>
 <tr><td>핫 크랙 (Hot Crack)</td><td>응고 응력</td><td>금형 온도·이형 시점</td></tr>
 <tr><td>인클루전 (Inclusion)</td><td>비금속 개재물</td><td>Spectro·리턴 비율 인터록</td></tr>
 <tr><td>플래시 (Flash)</td><td>금형 마모·체결력 부족</td><td>금형 수명·체결력 SPC</td></tr>
 <tr><td>치수 불량</td><td>금형 마모·열변형</td><td>CMM·SPC</td></tr>
 <tr><td>표면 불량</td><td>금형 표면·쇼트 부족</td><td>외관 자동 검사</td></tr>
 <tr><td>성분 불량</td><td>합금 표준 이탈</td><td>Spectro 인터록</td></tr>
 <tr><td>강도 부족</td><td>열처리 부족·합금</td><td>인장·경도 시험 SPC</td></tr>
 <tr><td>기공 (X-Ray NG)</td><td>주입 조건·리턴 과다</td><td>X-Ray/CT 인터록</td></tr>
 </tbody>
 </table>

'@

# 1.8 keypoint 직전에 심화 추가
$marker_ch1 = '<h4>1.8 1장 정리 — MES가 잡아야 할 주조 데이터 7가지</h4>'
$content = $content.Replace($marker_ch1, $ch1_deep + " " + $marker_ch1)
Write-Host "ch1 deepened"

# 주조편 2장 심화 — 2.5 정리 직전
$ch2_deep = @'

 <h4>2.4.1 OEM 규격 매트릭스 — 6 OEM × 7 항목</h4>
 <table class="nowrap-table">
 <thead><tr><th>항목</th><th>현대·기아</th><th>도요타</th><th>VW</th><th>BMW</th><th>GM</th><th>Ford</th></tr></thead>
 <tbody>
 <tr><td>품질 표준</td><td>MS</td><td>TSH</td><td>TL</td><td>BMW Standard</td><td>GMW</td><td>WSS-M</td></tr>
 <tr><td>SQ 시스템</td><td>SQ Mark 5★</td><td>GTQS</td><td>Formel-Q</td><td>Formel-Q</td><td>BIQS·CQI</td><td>Q1</td></tr>
 <tr><td>주조 평가</td><td>SQ 항목</td><td>TPS Audit</td><td>VDA 6.3</td><td>VDA 6.3</td><td>CQI-27</td><td>QSA</td></tr>
 <tr><td>합금 규격</td><td>MS 합금</td><td>JIS H</td><td>DIN EN</td><td>DIN EN</td><td>SAE J</td><td>WSS-M</td></tr>
 <tr><td>추적성</td><td>15년·Heat lot</td><td>15년·SVO 매핑</td><td>15년·VIN</td><td>15년·VIN</td><td>15년·GMS</td><td>15년·VIN</td></tr>
 <tr><td>NDT 요구</td><td>X-Ray·치수</td><td>CT·X-Ray·치수</td><td>CT·X-Ray·UT</td><td>CT·X-Ray·UT</td><td>X-Ray·CT</td><td>X-Ray·치수</td></tr>
 <tr><td>리턴 상한</td><td>30~50%</td><td>30~40%</td><td>20~35%</td><td>20~35%</td><td>30~50%</td><td>30~50%</td></tr>
 </tbody>
 </table>

 <h4>2.4.2 CQI-27 평가 12영역 240 항목 카탈로그</h4>
 <table>
 <thead><tr><th>영역</th><th>항목 수</th><th>MES 데이터 영역</th></tr></thead>
 <tbody>
 <tr><td>(1) 관리 책임</td><td>15</td><td>—</td></tr>
 <tr><td>(2) 인력·자격</td><td>20</td><td>작업자 마스터·교육 이력</td></tr>
 <tr><td>(3) 설비·금형</td><td>25</td><td>설비 마스터·금형 수명</td></tr>
 <tr><td>(4) 용해</td><td>30</td><td>Heat·Spectro·온도 트렌드</td></tr>
 <tr><td>(5) 주입·응고</td><td>25</td><td>주입 압력·응고 프로파일</td></tr>
 <tr><td>(6) 열처리</td><td>20</td><td>열처리 lot·온도 곡선</td></tr>
 <tr><td>(7) 기계가공</td><td>20</td><td>CMM·SPC·툴 수명</td></tr>
 <tr><td>(8) 검사</td><td>30</td><td>X-Ray·CT·치수·재료</td></tr>
 <tr><td>(9) 환경·안전</td><td>15</td><td>—</td></tr>
 <tr><td>(10) 문서·기록</td><td>15</td><td>PPAP·8D·CSR 자동 추출</td></tr>
 <tr><td>(11) 변경 관리</td><td>15</td><td>ECN·금형 변경</td></tr>
 <tr><td>(12) 시정 조치</td><td>10</td><td>CAPA·8D 이력</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>합계</td><td>240</td><td>약 75% MES 직접</td></tr>
 </tbody>
 </table>
 <p>CQI-27 등급: Level 1 (>90%·우수) / Level 2 (80~90%·합격) / Level 3 (<80%·시정 90일).</p>

 <h4>2.4.3 자동차 주조 부품 무게·합금 매트릭스 <em style="color:#8b3a2a;font-size:13px;font-weight:normal;">(저자 추정)</em></h4>
 <table>
 <thead><tr><th>부품</th><th>무게 (kg)</th><th>합금</th><th>차량 1대당 수</th></tr></thead>
 <tbody>
 <tr><td>엔진 블록 (4기통)</td><td>15~25</td><td>A356·319</td><td>1</td></tr>
 <tr><td>실린더 헤드 (4기통)</td><td>8~12</td><td>A356·A357</td><td>1~2</td></tr>
 <tr><td>미션 케이스</td><td>10~18</td><td>ADC12·A380</td><td>1</td></tr>
 <tr><td>알로이 휠 (1ea)</td><td>8~12</td><td>A356·T6</td><td>4 (스페어 제외)</td></tr>
 <tr><td>서스펜션 암</td><td>2~5</td><td>A356·T6</td><td>4~8</td></tr>
 <tr><td>오일팬</td><td>3~5</td><td>ADC12</td><td>1</td></tr>
 <tr><td>커버·하우징 (소형)</td><td>0.5~2</td><td>ADC12</td><td>5~10</td></tr>
 <tr style="font-weight:700;background:#f3ece0;"><td>차량 1대 주조 합계</td><td>~80~130 kg</td><td>알루미늄 합금</td><td>—</td></tr>
 </tbody>
 </table>
 <p>전기차는 + 배터리 케이스 (20~50kg)·모터 하우징 (10~20kg) 추가. 알루미늄 주조 비중이 ICE 차량 대비 1.5~2배.</p>

 <h4>2.4.4 사례 5종 — 주조 협력사 OEM 사고·우수 사례</h4>
 <div class="case">
 <div class="case-title">사례 1 — 다카타 에어백 인플레이터 (2014) 후폭풍, 주조 협력사 영향</div>
 <p>다카타 인플레이터 결함 이후 OEM 측이 안전 부품 협력사 전체 SQ 평가 강화. 안전 부품 주조 협력사들이 CT 100% 검사 의무화. MES + CT 통합 비용 평균 5~10억. 그 비용 부담 못한 협력사 다수가 폐업·M&A.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 2 — 현대 i30 N 휠 균열 클레임 (2020·가공)</div>
 <p>국내 모 알로이 휠 협력사. 휠 lot에서 LPDC 응고 결함 발견. MES Genealogy로 Heat → 잉곳 → 외부 스크랩 lot까지 5초 역추적. 영향 차량 1,200대로 좁힘 (전체 출하 8만 대 중). 리콜 비용 4억 (전수 리콜이었으면 26억). MES ROI 입증.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 3 — VW 디젤게이트 후 (2016) 부품 협력사 ESG 강화</div>
 <p>VW Formel-Q 평가에 ESG·CO2 가중치 추가. 주조 협력사 측 — 유도로(저CO2)로 전환·재활용 비율 추적 의무. 가스 반사로 협력사 거래 단절 사례 다수.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 4 — Tesla 4680 배터리 케이스 통합 다이캐스팅 (2022)</div>
 <p>Tesla가 Giga Press (6,000~9,000톤)로 차량 후방 차체를 한 번에 주조. 부품 70개 → 1개로 통합. 한국 협력사 다수가 Giga Press 전환 검토. 14개월 MES 도입 시 Giga Press 라인 대응 필수.</p>
 </div>
 <div class="case">
 <div class="case-title">사례 5 — 도요타 협력사 5 Why 사례</div>
 <p>도요타 미션 케이스 협력사 — 가스 기공 NG 0.8% → 0.05%로 감소. 5 Why·MES 인터록 결합. SQ 평가 +12점. 5년 거래 연장 + 신모델 우선 진입.</p>
 </div>

'@

$marker_ch2 = '<h4>2.5 2장 정리</h4>'
$content = $content.Replace($marker_ch2, $ch2_deep + " " + $marker_ch2)
Write-Host "ch2 deepened"

[System.IO.File]::WriteAllText($casting_file, $content, $utf8NoBom)
Write-Host "casting expanded"
