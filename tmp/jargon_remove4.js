const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

// 2차 잔존 처리 (자리별)
const replacements = [
  // 헌장·합의 자리 (베트남 본사-자회사 통합 운영)
  ['거버넌스 헌장', '통합 운영 헌장'],
  ['거버넌스 합의', '통합 운영 합의'],

  // 챕터 제목·헤더
  ['9.2 거버넌스 체계', '9.2 운영 체계'],
  ['43.3 본사·법인 거버넌스', '43.3 본사·법인 운영 체계'],

  // GenAI / 글로벌
  ['GenAI 거버넌스', 'GenAI 운영 체계'],
  ['글로벌 거버넌스', '글로벌 운영'],

  // 21장 (마스터데이터 관리 — 이미 변환됨, 잔존 자리는 풀이)
  ['21장 거버넌스', '21장 마스터데이터 관리'],

  // 일반 풀이
  ['거버넌스 수립', '운영 체계 수립'],
  ['거버넌스 안정', '운영 안정'],
  ['거버넌스의 출발점', '운영 체계의 출발점'],
  ['정교한 거버넌스', '정교한 운영 체계'],
  ['거버넌스의 일', '운영 체계의 일'],
  ['자동화도 거버넌스', '자동화도 운영 체계'],

  // 킥오프 어젠다 (마지막 fallback)
  ['거버넌스</strong>', '운영 체계</strong>'],

  // 단독 거버넌스 (잔존 — 마지막)
  ['거버넌스', '운영 체계'],
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

const remaining = c.match(/거버넌스/g) || [];
console.log(`\n잔존 거버넌스: ${remaining.length}건`);
