const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

const reverts = [
  ['수요를 미리 예측해 제품을 만들어 둔다. SAP에서는 Strategy 10과 40으로 설정한다.',
   '수요를 미리 예측해 제품을 만들어 두는 전략이다. SAP에서는 Strategy 10과 40으로 설정한다.'],
  ['고객 주문이 확정된 다음에 생산을 시작한다. SAP Strategy 20에 해당한다.',
   '고객 주문이 확정된 다음에 생산을 시작하는 전략이다. SAP Strategy 20에 해당한다.'],
  ['고객별 설계부터 새로 시작한다. SAP Strategy 50과 PS 모듈을 함께 쓴다.',
   '고객별 설계부터 새로 시작하는 전략이다. SAP Strategy 50과 PS 모듈을 함께 쓴다.'],
  ['미리 정의한 옵션을 조합해 변형을 자동으로 만들어낸다. SAP Variant Configurator(VC)와 매트릭스 BOM을 쓴다.',
   '미리 정의한 옵션을 조합해 변형을 자동으로 만들어내는 전략이다. SAP Variant Configurator(VC)와 매트릭스 BOM을 쓴다.'],
  ['국제상업회의소(ICC)가 무역 운송조건을 11가지 약어로 표준화해 운영한다. 매도인과 매수인 사이의 책임·비용·위험 분담을 약어별로 정한다. 2020년판을 현재 표준으로 쓴다.',
   '인코텀즈는 국제상업회의소(ICC)가 정한 무역 운송조건의 표준이다. 매도인과 매수인 사이의 책임·비용·위험 분담을 11가지 약어로 정한다. 2020년판이 현재 적용 표준이다.'],
  ['매도인이 매수인이 지정한 운송인에게 물건을 인도한다. 컨테이너 시대에 표준으로 쓴다.',
   '매도인이 매수인이 지정한 운송인에게 물건을 인도한다. 컨테이너 시대의 표준 조건이다.'],
  ['Prosci가 변화관리 표준으로 정립해 운영한다. Awareness(인식)·Desire(욕망)·Knowledge(지식)·Ability(능력)·Reinforcement(강화) 다섯 단계로 변화를 끌어간다. ERP 도입처럼 큰 변화에 적용한다. 개인 단위 변화에 초점을 둔다.',
   'Prosci가 개발한 변화관리 표준 모델이다. Awareness(인식)·Desire(욕망)·Knowledge(지식)·Ability(능력)·Reinforcement(강화) 다섯 단계로 변화를 끌어간다. ERP 도입처럼 큰 변화에 적용한다. 개인 단위 변화에 초점이 있다.'],
  ['Harvard의 John Kotter가 변화 리더십 8단계로 정립했다. Urgency(긴급성 조성)·Coalition(연합체 구성)·Vision(비전 수립)·Communicate(소통)·Empower(권한 부여)·Wins(단기 성과)·Consolidate(공고화)·Anchor(정착)로 흐른다. ADKAR이 개인 변화에 초점을 두는 반면 Kotter는 조직 변화를 다룬다.',
   'Harvard의 John Kotter가 제시한 변화 리더십 8단계다. Urgency(긴급성 조성)·Coalition(연합체 구성)·Vision(비전 수립)·Communicate(소통)·Empower(권한 부여)·Wins(단기 성과)·Consolidate(공고화)·Anchor(정착)로 흐른다. ADKAR이 개인 변화에 초점이라면 Kotter는 조직 변화에 초점이 있다.'],
  ['SAP가 도입에 표준으로 채택해 운영한다. Discover·Prepare·Explore·Realize·Deploy·Run 6단계로 흐른다. S/4HANA Cloud와 On-Premise 모두 적용한다. 2018년부터 SAP의 공식 표준으로 쓴다.',
   'SAP의 표준 도입 방법론이다. Discover·Prepare·Explore·Realize·Deploy·Run 6단계로 흐른다. S/4HANA Cloud와 On-Premise 모두 적용한다. 2018년부터 SAP의 공식 표준이다.'],
  ['Oracle이 도입에 표준으로 운영한다. Oracle EBS·Fusion·NetSuite 도입에 쓴다. Inception·Elaboration·Construction·Transition 4단계로 흐른다.',
   'Oracle의 도입 방법론이다. Oracle EBS·Fusion·NetSuite 도입에 쓴다. Inception·Elaboration·Construction·Transition 4단계로 흐른다.'],
  ['한국이 IFRS를 채택해 한국 환경에 맞춰 일부 조정해 운영한다. 상장기업과 일부 비상장 대기업이 의무로 따른다. 2011년부터 시행했다.',
   '한국이 IFRS를 채택해 한국 환경에 맞춰 일부 조정한 회계기준이다. 상장기업과 일부 비상장 대기업이 의무로 따른다. 2011년부터 시행했다.'],
  ['한국회계기준원이 제정해 운영하고, 한국의 비상장 기업이 따른다.',
   '한국의 비상장 기업이 따르는 회계기준이다. 한국회계기준원이 제정·운영한다.'],
  ['미국 재무회계기준위원회(FASB)가 제정해 운영한다. 미국 SEC 상장기업과 미국에 진출한 한국 기업이 따른다.',
   '미국 재무회계기준위원회(FASB)가 제정한 미국 회계기준이다. 미국 SEC 상장기업과 미국에 진출한 한국 기업이 따른다.'],
  ['국제회계기준위원회(IASB)가 글로벌 회계 표준으로 제정해 운영한다. EU·호주·일본 일부·한국(K-IFRS) 등 140여 개국이 채택했다.',
   '국제회계기준위원회(IASB)가 제정한 글로벌 회계 표준이다. EU·호주·일본 일부·한국(K-IFRS) 등 140여 개국이 채택했다.'],
  ['2002년 미국이 Enron·WorldCom 회계 부정 사건 후 내부통제법으로 제정했다. 상장기업 CEO·CFO에게 재무제표 정확성에 대한 형사 책임을 부여한다.',
   '2002년 미국이 Enron·WorldCom 회계 부정 사건 후 제정한 내부통제법이다. 상장기업 CEO·CFO에게 재무제표 정확성에 대한 형사 책임을 부여한다.'],
  ['SCOR(Supply Chain Operations Reference)는 ASCM(전 APICS)이 1996년부터 공급망 표준 모델로 개발해 운영한다. 공급망 활동을 6단계 프로세스로 나눠 측정·진단·개선 기준을 제공한다.',
   'SCOR(Supply Chain Operations Reference)는 ASCM(전 APICS)이 1996년부터 개발한 공급망 표준 모델이다. 공급망 활동을 6단계 프로세스로 나눠 측정·진단·개선 기준을 제공한다.'],
  ['수요 예측, 공급 계획, 능력 계획, 자재 계획을 다룬다. 모든 공급망 활동이 여기서 출발한다. S&amp;OP가 중심에서 흐름을 이끈다.',
   '수요 예측, 공급 계획, 능력 계획, 자재 계획을 다룬다. 모든 공급망 활동의 출발점이다. S&amp;OP가 핵심이다.'],
  ['반품 처리, 회수, 폐기, A/S를 다룬다. SCOR 모델이 다른 모델보다 이 단계를 강조한다.',
   '반품 처리, 회수, 폐기, A/S를 다룬다. SCOR 모델이 다른 모델보다 강조하는 부분이다.'],
  ['계약·법규·정보 시스템·인적자원 등으로 위 5단계를 받친다. 2017년 SCOR 12.0부터 명시적으로 추가됐다.',
   '계약·법규·정보 시스템·인적자원 등 위 5단계를 받치는 기반이다. 2017년 SCOR 12.0부터 명시적으로 추가됐다.'],
  ['ASCM(전 APICS)이 1973년부터 자격증으로 운영한다. 1년차에서 5년차 컨설턴트가 가장 먼저 잡는다. Part 1과 Part 2로 구성된다. 2026년 6월부터 CPIM 9.0 버전이 적용된다.',
   'ASCM(전 APICS)이 1973년부터 운영하는 자격증이다. 1년차에서 5년차 컨설턴트의 기본 무기다. Part 1과 Part 2로 구성된다. 2026년 6월부터 CPIM 9.0 버전이 적용된다.'],
  ['APICS Dictionary 16판을 이 자격증의 표준 용어 사전으로 쓴다.',
   'APICS Dictionary 16판이 이 자격증의 표준 용어 사전이다.'],
  ['공급망 전반을 다루는 시니어 자격증으로 운영한다. CPIM이 생산·재고에 초점을 둔다면 CSCP는 공급망 설계·운영·전략까지 포함한다. 시니어 매니저급 이상이 도전한다.',
   '공급망 전반을 다루는 시니어 자격증이다. CPIM이 생산·재고 중심이라면 CSCP는 공급망 설계·운영·전략까지 포함한다. 시니어 매니저급 이상이 도전한다.'],
  ['2016년 물류와 운송에 특화해 신설했다. 글로벌 3자 물류(3PL) 회사와 유통 컨설턴트가 따른다.',
   '물류와 운송에 특화된 자격증이다. 2016년 신설됐다. 글로벌 3자 물류(3PL) 회사와 유통 컨설턴트가 따른다.'],
  ['기업이 자금을 조달할 때 부담하는 평균 비용을 산출한다. 자기자본 비용과 타인자본 비용을 각각의 비중으로 가중평균해 계산한다.',
   '기업이 자금을 조달하는 평균 비용이다. 자기자본 비용과 타인자본 비용을 각각의 비중으로 가중평균해 산출한다.'],
  ['공급사에 지급해야 할 외상매입금을 다룬다. SAP FI-AP 모듈에서 처리한다. 3-Way Match(PO ↔ GR ↔ Invoice)로 검증한다.',
   '공급사에 지급해야 할 외상매입금이다. SAP FI-AP 모듈이 다룬다. 3-Way Match(PO ↔ GR ↔ Invoice)로 검증한다.'],
  ['고객으로부터 받아야 할 외상매출금을 다룬다. SAP FI-AR 모듈에서 처리한다. 신용 한도, 회수 관리, 대손 충당이 핵심을 이룬다.',
   '고객으로부터 받아야 할 외상매출금이다. SAP FI-AR 모듈이 다룬다. 신용 한도, 회수 관리, 대손 충당이 핵심이다.'],
  ['SAP가 통합 클라우드 플랫폼으로 운영한다. 데이터·AI·확장 개발·통합을 한 플랫폼에서 처리한다. Clean Core 원칙에 따라 S/4HANA의 커스텀은 BTP에서 개발한다.',
   'SAP의 통합 클라우드 플랫폼이다. 데이터·AI·확장 개발·통합을 한 플랫폼에서 처리한다. Clean Core 원칙에 따라 S/4HANA의 커스텀은 BTP에서 개발한다.'],
];

let count = 0;
const log = [];
for (const [from, to] of reverts) {
  if (c.includes(from)) {
    c = c.replace(from, to);
    count++;
  } else {
    log.push(`  매칭 실패: ${from.slice(0, 50)}...`);
  }
}

fs.writeFileSync(src, c, 'utf8');
console.log(`${count}/${reverts.length} 롤백`);
if (log.length) log.forEach(l => console.log(l));
