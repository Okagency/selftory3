const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

// 메모리 [거버넌스 jargon 금지] 매핑 적용
// 순서 중요 — 구체적인 패턴 먼저 (긴 것 → 짧은 것)
const replacements = [
  // 챕터 제목·목차 (한국어 풀이 우선)
  ['21장 마스터데이터 거버넌스', '21장 마스터데이터 관리'],
  // 정의·약자 보존
  ['마스터데이터 거버넌스(MDM)', '마스터데이터 관리(MDM)'],
  ['마스터데이터 거버넌스', '마스터데이터 관리'],
  ['MDM 거버넌스', 'MDM 운영 체계'],
  ['마스터 거버넌스(MDG)', '마스터 관리(MDG)'],
  ['마스터 거버넌스', '마스터 관리'],
  // 자리별 매핑
  ['통합 거버넌스', '통합 운영'],
  ['거버넌스 5종 회의체', '5종 회의체'],
  ['거버넌스 회의체', '회의체'],
  ['거버넌스 워크플로', '운영 워크플로'],
  ['책임 거버넌스', '책임 체계'],
  ['표준원가 거버넌스', '표준원가 관리'],
  ['1차 거버넌스', '1차 통합 운영'],
  ['거버넌스 위원회', '운영 위원회'],
  ['거버넌스 거부', '운영 룰 거부'],
  ['거버넌스 정례화', '회의체 정례화'],
  ['다채널 거버넌스', '다채널 운영 체계'],
  ['SCM 거버넌스', 'SCM 운영 체계'],
  ['구매 거버넌스', '구매 운영 체계'],
  ['시즈카 거버넌스', '시즈카 운영 권한'],
  ['To-Be 거버넌스', 'To-Be 운영 체계'],
];

let total = 0;
const log = [];
for (const [pat, rep] of replacements) {
  const escaped = pat.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const re = new RegExp(escaped, 'g');
  const matches = c.match(re) || [];
  if (matches.length > 0) {
    c = c.replace(re, rep);
    total += matches.length;
    log.push(`  "${pat}" → "${rep}": ${matches.length}건`);
  }
}

fs.writeFileSync(src, c, 'utf8');

console.log(`총 ${total}건 변환`);
log.forEach(l => console.log(l));

// 잔존 컨텍스트
const remaining = c.match(/.{0,40}거버넌스.{0,40}/g) || [];
console.log(`\n잔존 거버넌스: ${remaining.length}건`);
remaining.forEach((line, i) => {
  console.log(`  ${i + 1}. ${line.replace(/\s+/g, ' ')}`);
});
