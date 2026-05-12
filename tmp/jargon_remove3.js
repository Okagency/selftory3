const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

const replacements = [
  // 잠깐 → 잠시 (자연스러운 한국어)
  ['잠깐', '잠시'],

  // 곽 → 담뱃갑 (흡연 묘사 룰)
  ['곽', '담뱃갑'],

  // 모습 — jargon 어미·조사
  ['모습이었다', '이었다'],
  ['모습이지', '거지'],
  ['모습예요', '거예요'],
  ['모습이에요', '거예요'],
  ['모습이고요', '거고요'],
  ['모습입니다', '겁니다'],
  ['모습입니까', '겁니까'],
  // 모습 + 조사 (사람 표정 컨텍스트가 대부분)
  ['그 모습', '그 표정'],
  ['이 모습', '이 표정'],
  ['한 모습', '한 표정'],
  ['모습은', '표정은'],
  ['모습을', '표정을'],
  ['모습이', '표정이'],
  ['모습으로', '표정으로'],
  ['모습에', '표정에'],
  // 단독 모습 잔존 처리
  ['모습', '모양'],

  // 분위기 — jargon 어미·조사
  ['분위기였', '이었'],
  ['분위기예요', '거예요'],
  ['분위기이에요', '거예요'],
  ['분위기이고요', '거고요'],
  ['분위기입니다', '겁니다'],
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
console.log(`3차 ${total}건 변환`);
log.forEach(l => console.log(l));

console.log('\n[잔존 자곤 빈도]');
const words = ['장면', '모습', '분위기', '잠깐', '살짝', '곽', '묘하게'];
for (const w of words) {
  const re = new RegExp(w, 'g');
  const m = content.match(re) || [];
  console.log(`  ${w}: ${m.length}`);
}
