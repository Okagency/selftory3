const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

// 2차 자곤 박멸 — 더 공격적 패턴
const replacements = [
  // 장면 + 조사 일괄
  ['장면을', '자리를'],
  ['장면의', '자리의'],
  ['장면이', '자리가'],
  ['장면에서', '자리에서'],
  ['장면에', '자리에'],
  ['장면도', '자리도'],
  ['장면만', '자리만'],
  ['장면과', '자리와'],
  ['장면도', '자리도'],
  ['장면은', '자리는'],
  ['장면는', '자리는'],
  ['장면입', '자리입'],
  ['장면', '자리'],  // 잔존 단독 — 마지막

  // 살짝 → 약간
  ['살짝', '약간'],

  // 모습 jargon 어미
  ['모습였', '이었'],
  ['모습이지', '거지'],

  // 분위기 어색한 어미
  ['분위기였', '이었'],
];

let total = 0;
const log = [];
for (const [pat, rep] of replacements) {
  const escaped = pat.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const re = new RegExp(escaped, 'g');
  const matches = content.match(re) || [];
  if (matches.length > 0) {
    content = content.replace(re, rep);
    total += matches.length;
    log.push(`  "${pat}" → "${rep}": ${matches.length}건`);
  }
}

fs.writeFileSync(src, content, 'utf8');
console.log(`2차 ${total}건 변환`);
log.forEach(l => console.log(l));

console.log('\n[잔존 자곤 빈도]');
const words = ['장면', '모습', '분위기', '잠깐', '살짝', '곽'];
for (const w of words) {
  const re = new RegExp(w, 'g');
  const m = content.match(re) || [];
  console.log(`  ${w}: ${m.length}`);
}
