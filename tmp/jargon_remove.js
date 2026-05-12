const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

// 명백 jargon 패턴 (안전한 자동 치환)
const replacements = [
  // 장면 어미 jargon
  ['장면고요', '거고요'],
  ['장면이고요', '거고요'],
  ['장면이지요', '거지요'],
  ['장면예요', '거예요'],
  ['장면이에요', '거예요'],
  ['장면입니다', '겁니다'],
  ['장면이었다', '이었다'],
  ['장면였다', '이었다'],
  ['장면이지', '거지'],

  // 장면 + 자리 의미 패턴
  ['회식 장면', '회식 자리'],
  ['회의실 장면', '회의실 자리'],
  ['그 장면에서', '그 자리에서'],
  ['이 장면에서', '이 자리에서'],
  ['한 장면에서', '한 자리에서'],
  ['어느 장면에서', '어느 자리에서'],
  ['그 장면', '그 자리'],
  ['이 장면', '이 자리'],
  ['한 장면', '한 자리'],

  // 분위기 jargon
  ['분위기으로', '처럼'],

  // 모습 jargon
  ['모습였다', '이었다'],
  ['모습이었다', '이었다'],
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
console.log(`총 ${total}건 변환`);
log.forEach(l => console.log(l));

// 잔존 자곤 빈도 보고
console.log('\n[잔존 자곤 빈도]');
const words = ['장면', '모습', '분위기', '잠깐', '살짝', '곽', '묘하게'];
for (const w of words) {
  const re = new RegExp(w, 'g');
  const m = content.match(re) || [];
  console.log(`  ${w}: ${m.length}`);
}
