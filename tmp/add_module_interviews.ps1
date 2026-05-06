[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 10.3 PP 끝 다음, 10.4 회의록 직전에 새 모듈 인터뷰 표준 질문 7개 모듈 추가
$marker = ' <h4>10.4 인터뷰 회의록 — 24시간 안에 송부하는 양식</h4>'
$insertion = @'
 <h4>10.4 MM 모듈 인터뷰 표준 질문 35개 — 자재·구매</h4> <ol>
 <li>주요 자재 카테고리(원자재·반제품·완제품·소모품·포장재) 비중은?</li>
 <li>자재 코드 체계와 코드 부여 룰은? (의미 코드 vs 일련번호)</li>
 <li>자재 마스터 등록·변경 권한과 승인 절차는?</li>
 <li>월 평균 발주(PO) 건수와 평균 PO 라인 수는?</li>
 <li>발주 유형 비중은? (정상·외주가공·재공급·소모품·서비스)</li>
 <li>발주 승인 한도는 직급별로 어떻게 정해져 있나?</li>
 <li>매입 시 3-Way Match(PO·GR·Invoice) 적용 비율은?</li>
 <li>매입 가격 변동 추적 방식은? (정보레코드·계약·견적)</li>
 <li>외주가공 사급재 관리 — Subcontracting 비중과 정산 방식은?</li>
 <li>긴급 구매(Emergency PO) 빈도와 처리 절차는?</li>
 <li>공급업체 평가 기준 5가지는? (품질·납기·가격·서비스·재무)</li>
 <li>주요 공급업체 수와 단일 공급(Single Source) 비중은?</li>
 <li>입고(Goods Receipt) 검수 절차와 부적합 처리는?</li>
 <li>재고 평가법은? (표준원가·이동평균·FIFO·실제)</li>
 <li>월말 재고 실사 주기와 차이 처리 룰은?</li>
 <li>안전재고 정책 — 자재별 차등인가 일괄인가?</li>
 <li>재고 회전율과 데드 스톡(Dead Stock) 관리는?</li>
 <li>VMI(Vendor Managed Inventory) 운영 자재가 있나?</li>
 <li>매입 부대비용(운송·하역·보험·관세) 처리 방식은?</li>
 <li>수입 매입의 인코텀즈 적용 비율은? (FOB·CIF·EXW 등)</li>
 <li>FTA 활용 비중과 원산지 증명 발급 방식은?</li>
 <li>매입 결제 조건(Payment Terms) 표준은?</li>
 <li>매입 회계분개 자동화 비율과 OBYC 설정 상태는?</li>
 <li>구매팀 인원 구성과 시스템 사용자 수는?</li>
 <li>발주처~입고처~결제처 분리(SoD)는 어떻게?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>월말 결산 시 구매팀이 회계팀에 제출하는 자료는?</li>
 <li>구매·외주·소모품 3종 PO의 처리 차이점은?</li>
 <li>EDI 거래 비중과 주요 거래처는?</li>
 <li>베트남 법인의 매입과 한국 본사의 매입 차이점은?</li>
 <li>매입 단가 협상 사이클(연간·분기·수시)은?</li>
 <li>K-IFRS 매입원가 정합성 — 외부감사 지적 이력은?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.5 SD 모듈 인터뷰 표준 질문 35개 — 영업·물류</h4> <ol>
 <li>주요 고객 카테고리(OEM·대리점·직판·해외수출) 비중은?</li>
 <li>고객 마스터 등록 절차와 신용한도 부여 룰은?</li>
 <li>월 평균 수주(SO) 건수와 평균 SO 라인 수는?</li>
 <li>주요 판매 방식(MTS·MTO·BTO·ETO)의 비중은?</li>
 <li>고객별 가격 정책 — 정가·할인·계약가·VIP 차등 운영은?</li>
 <li>가격 결정 권한은 누구에게? 영업 사원·팀장·임원 한도는?</li>
 <li>견적(Quotation)에서 수주(Order)로 전환되는 평균 비율은?</li>
 <li>판매 사이클 — 견적부터 청구까지 평균 며칠?</li>
 <li>ATP(Available to Promise) 응답 가능 비율은?</li>
 <li>출하(Delivery) 통합 처리 — 부분 출하·일괄 출하 비중은?</li>
 <li>운송업체 관리와 운송비 정산 방식은?</li>
 <li>인코텀즈(FOB·CIF·EXW) 적용 거래 비율은?</li>
 <li>수출 거래 — 신용장(L/C)·D/A·D/P·T/T 결제 방식 비중은?</li>
 <li>반품·교환·환불 처리 절차와 월 발생 건수는?</li>
 <li>매출 인식 시점 — 출하 vs 입고 vs Sign-off?</li>
 <li>매출 할인·리베이트·판매 장려금 운영 룰은?</li>
 <li>고객 신용한도 초과 시 처리 절차는?</li>
 <li>매출채권 회수 사이클(DSO)과 관리 주기는?</li>
 <li>해외 수출 — 다중 통화 처리와 환차손 관리는?</li>
 <li>SD-FI Inter-company billing 적용 거래는?</li>
 <li>판매 KPI 5개 — 매출·마진·OTIF·DSO·반품률 외?</li>
 <li>영업팀 KPI와 매출 인식 시점 충돌은 없나?</li>
 <li>견적 단계 가격 검증 자동화 비율은?</li>
 <li>주요 고객별 EDI 운영(IDoc·EDIFACT)은?</li>
 <li>고객 클레임 처리 시스템(Complaint Management)은?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>매출 인식 시점이 K-IFRS 1115호와 정합한지 검증되었나?</li>
 <li>월말 결산 시 영업팀이 회계팀에 제출하는 자료는?</li>
 <li>영업팀 인원 구성과 시스템 사용자 수는?</li>
 <li>베트남 매출과 한국 본사 매출의 분리 정합성은?</li>
 <li>주요 고객 협상 사이클(연간 단가 갱신)과 KPI는?</li>
 <li>고객 수익성 분석(CO-PA) 운영 여부는?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.6 FI 모듈 인터뷰 표준 질문 35개 — 재무회계</h4> <ol>
 <li>현재 회계 시스템과 주요 모듈(GL·AR·AP·AM·Bank)은?</li>
 <li>차트 오브 어카운츠(CoA) 구조와 계정 수는?</li>
 <li>K-IFRS 적용 여부와 K-GAAP 병행 운영은?</li>
 <li>외부감사인은 누구이며 KAM(핵심감사사항) 항목은?</li>
 <li>월·분기·반기·연 결산 일정과 마감 일수는?</li>
 <li>결산 시 수기 분개(JE) 비중과 자동분개 비율은?</li>
 <li>발생주의 vs 현금주의 적용 영역 분리는?</li>
 <li>자동분개 룰(OBYC) 매핑 정확도는?</li>
 <li>외화 환산 — 매월 평균환율·기말환율 적용 룰은?</li>
 <li>재평가(Revaluation) 주기와 처리 자동화는?</li>
 <li>매출채권(AR) Aging 분석 주기와 충당금 설정은?</li>
 <li>매입채무(AP) 결제 사이클과 어음 운영 비중은?</li>
 <li>법인카드·소액 경비 처리 절차는?</li>
 <li>고정자산(Asset) 관리 — 감가상각법·내용연수 정책은?</li>
 <li>리스 회계(K-IFRS 1116호) 처리 자동화 수준은?</li>
 <li>금융상품 평가 — FVOCI·FVPL 분류 룰은?</li>
 <li>충당부채·우발부채 인식 기준 명문화 여부는?</li>
 <li>퇴직급여 회계(K-IFRS 1019호) 처리 방식은?</li>
 <li>이연법인세(Deferred Tax) 자동 계산 여부는?</li>
 <li>연결결산 범위와 내부거래 제거 방식은?</li>
 <li>다중 원장(Parallel Ledger) 운영 여부 — K-IFRS·VAS·Group?</li>
 <li>외부감사 PBC 리스트와 준비 자료 표준화는?</li>
 <li>세무신고(법인세·부가세·원천세) 자동화 수준은?</li>
 <li>전자세금계산서 발급·수신 시스템 연계는?</li>
 <li>현금흐름표(CFS) 작성 자동화 수준은?</li>
 <li>회계팀 인원 구성과 SoD(직무분리) 적용은?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>D+5 마감 가능성 — 현재 마감 일수와 단축 목표는?</li>
 <li>K-SOX(내부회계관리제도) 적용 통제 항목은?</li>
 <li>외부감사 매년 지적 항목 Top 3는?</li>
 <li>IPO·M&amp;A 일정 — 회계 정합성 압박은?</li>
 <li>베트남 법인 회계와 한국 본사 결산 일정 동기화는?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.7 CO 모듈 인터뷰 표준 질문 30개 — 관리회계·원가</h4> <ol>
 <li>원가 평가법은? (표준원가·이동평균·실제·FIFO 자재유형별)</li>
 <li>표준원가 갱신 주기와 결재 절차는?</li>
 <li>표준원가 vs 실제원가 차이 평균 % 와 분석 주기는?</li>
 <li>차이배부(Variance Settlement) 룰 명문화 여부는?</li>
 <li>Material Ledger / Actual Costing 활용 여부는?</li>
 <li>비용 배부(Allocation) 룰 — Cycle·Segment 운영은?</li>
 <li>활동기준원가(ABC) 도입 여부와 활동 수는?</li>
 <li>CO-PA Operating Concern 설계 — Characteristic 수는?</li>
 <li>제품별·고객별·채널별 마진 분석 가시화 수준은?</li>
 <li>다단계 공헌이익(Contribution Margin Layers) 운영은?</li>
 <li>예산(Budget) 수립 주기와 운영 단위(BU·CC·PC)는?</li>
 <li>예산 vs 실적 차이 분석 자동화 수준은?</li>
 <li>비용 중심점(Cost Center) 수와 책임자 매핑은?</li>
 <li>이익 중심점(Profit Center) 운영 여부와 분리 룰은?</li>
 <li>Internal Order 활용 — 일회성 비용 추적 방식은?</li>
 <li>WBS 활용 — 프로젝트 원가 추적은?</li>
 <li>Target Costing 적용 제품군은?</li>
 <li>매월 차이 Top 20 분석과 액션 사이클은?</li>
 <li>제조원가명세서 자동 생성 여부는?</li>
 <li>외주가공 원가 처리 방식은?</li>
 <li>이전가격(Transfer Pricing) 운영 — 본사·자회사 단가 결정은?</li>
 <li>운전자본 KPI(재고회전·DSO·DPO) 관리 주기는?</li>
 <li>의사결정 지원 — Make-or-Buy·BEP 분석 운영은?</li>
 <li>경영진 대시보드(BI·Fiori)에 표시되는 핵심 KPI 5개는?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>가격 결정 — 영업팀과 원가팀의 데이터 일치도는?</li>
 <li>월결산 후 차이분석 보고 일정과 청중은?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.8 QM 모듈 인터뷰 표준 질문 25개 — 품질</h4> <ol>
 <li>품질검사 종류 — 입고·공정·출하 검사 비중은?</li>
 <li>월 평균 검사 로트 수와 표본 추출 방식은?</li>
 <li>검사 항목(MIC) 마스터 정합성 수준은?</li>
 <li>부적합(Non-Conformance) 처리 절차와 월 건수는?</li>
 <li>고객 클레임 처리 시스템(8D Report) 운영 여부는?</li>
 <li>품질 KPI 5개 — 불량률·재작업률·CPK·반품률·고객만족도?</li>
 <li>외주가공 입고 검사 비중과 부적합 처리는?</li>
 <li>SPC(통계적 공정관리) 적용 공정과 도구는?</li>
 <li>측정장비(Calibration) 관리와 ERP 연계는?</li>
 <li>품질 인증(ISO 9001·IATF 16949·AS9100) 보유는?</li>
 <li>PPAP(Production Part Approval Process) 패키지 자동화는?</li>
 <li>SCAR(Supplier Corrective Action Request) 처리 방식은?</li>
 <li>로트 추적성 — 부품 단위 추적 가능 여부는?</li>
 <li>품질 비용(COQ) 관리 — 예방·평가·실패비용 분리는?</li>
 <li>샘플링 플랜(AQL·MIL-STD-105E) 적용 자재는?</li>
 <li>품질팀 인원 구성과 시스템 사용자 수는?</li>
 <li>고객 감사(Audit) 대응 빈도와 준비 자료는?</li>
 <li>리콜·재작업 처리 절차와 비용 추적은?</li>
 <li>SLED(Shelf Life Expiration Date) 관리 자재는?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>품질-생산-구매 3팀 협업 워크플로 정합성은?</li>
 <li>품질 데이터의 회계 인식(불량 비용·폐기) 자동화는?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.9 HCM 모듈 인터뷰 표준 질문 25개 — 인사</h4> <ol>
 <li>총 인원과 직군별·직급별 분포는?</li>
 <li>고용형태 비중(정규·계약·파견·일용)은?</li>
 <li>조직구조 — 본사·자회사·해외법인 별도 운영인가?</li>
 <li>급여 산정 방식 — 호봉제·직무급·연봉제 비중은?</li>
 <li>월 급여 처리 시스템과 마감일은?</li>
 <li>4대보험·소득세·지방세 자동 계산 정확도는?</li>
 <li>퇴직금 처리(DB·DC) 운영 비중은?</li>
 <li>연차·휴가 관리 시스템과 사용률은?</li>
 <li>출퇴근 관리(GPS·지문·IC) 시스템 연계는?</li>
 <li>인사고과·평가 시스템 운영 주기와 도구는?</li>
 <li>채용 관리 시스템(ATS)과 ERP 연계는?</li>
 <li>교육·자격증 관리 시스템 운영 여부는?</li>
 <li>해외 주재원 — 이중 급여·세무 처리 방식은?</li>
 <li>스톡옵션·우리사주 운영과 회계 처리는?</li>
 <li>전자결재 시스템과 ERP 권한 연계는?</li>
 <li>개인정보 보호(GDPR·개인정보보호법) 준수 수준은?</li>
 <li>인사 KPI 5개 — 이탈률·근속·교육시간·다양성·만족도?</li>
 <li>월 급여 정산 시 회계팀과의 데이터 흐름은?</li>
 <li>HR 분석(People Analytics) 도입 여부는?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>노사관계·노조 협약 사항이 시스템에 반영되어야 하는지?</li>
 <li>인사팀 인원과 시스템 사용자 수는?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <h4>10.10 PLM 모듈 인터뷰 표준 질문 25개 — 제품수명주기</h4> <ol>
 <li>현재 PLM 시스템(PTC·Teamcenter·ENOVIA·Aras)은?</li>
 <li>CAD 도구(Creo·NX·CATIA·SolidWorks) 비중은?</li>
 <li>제품 카테고리별 도면 등록 건수는?</li>
 <li>도면 Rev(Revision) 관리 룰과 승인 절차는?</li>
 <li>EBOM과 MBOM 분리 운영 여부와 변환 룰은?</li>
 <li>설계변경(ECO) 연 발생 건수와 평균 처리 기간은?</li>
 <li>ECN·ECR·ECO 3단계 워크플로 운영은?</li>
 <li>설계변경 영향도 분석(Where-Used) 자동화 수준은?</li>
 <li>품번(Part Number) 부여 룰과 코드 체계는?</li>
 <li>부품 분류(Classification) 체계 운영은?</li>
 <li>외주 설계 협업과 도면 외부 송신 보안은?</li>
 <li>도면-BOM-라우팅 정합성 검증 방식은?</li>
 <li>설계 표준화율(공통 부품 활용률)은?</li>
 <li>R&amp;D 비용 추적 — 프로젝트별·제품별 분리는?</li>
 <li>품질 인증(PPAP·자동차 OEM 승인) 패키지 자동화는?</li>
 <li>특허·지적재산 관리 시스템 연계는?</li>
 <li>제품 단종(Discontinuation) 절차와 잔여 재고 처리는?</li>
 <li>고객 맞춤 설계(Configuration) 비중과 자동화는?</li>
 <li>설계 BOM과 SAP MBOM 동기화 인터페이스는?</li>
 <li>현재 시스템에서 가장 답답한 5가지는?</li>
 <li>새 시스템에서 반드시 되어야 하는 3가지는?</li>
 <li>설계팀 인원과 PLM 사용자 수는?</li>
 <li>제품수명주기 단계별(컨셉·설계·시제품·양산·서비스·단종) 데이터 흐름은?</li>
 <li>혹시 빼먹은 질문이 있을까요?</li>
 <li>이 주제로 누구를 더 만나야 할까요?</li>
 </ol>

 <p><strong>모듈 표준 질문 사용 가이드</strong> — 각 모듈 인터뷰 1회당 30~40개 질문 중 10~15개를 사전 선정. 나머지는 대화 흐름에 따라 던진다. 동일 모듈은 임원·팀장·실무자 3계층 인터뷰 권장 (케이스 10.1 참조). 답이 다르면 그 차이가 진짜 발견. 회의록은 24시간 안에 송부 (10.4 양식).</p>

'@

if ($c.Contains($marker)) {
    $c = $c.Replace($marker, $insertion + $marker)
    Write-Host "7개 모듈 인터뷰 표준 질문 추가 완료"
} else {
    Write-Host "marker 못 찾음"
}

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "총 변화: $beforeLen -> $afterLen (증가 $($afterLen - $beforeLen)자)"
