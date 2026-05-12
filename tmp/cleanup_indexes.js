const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

// 1) sumScenes 라벨 시작의 일련번호 "NN. " 제거 (마커 이후)
//    예: "['scene-park-jisu', '02. 9장 ...']" → "['scene-park-jisu', '9장 ...']"
//    예: "['scene-mother-vn', '★ 06. 12장 ...']" → "['scene-mother-vn', '★ 12장 ...']"
let c2 = c.replace(/(\[\s*'[^']+',\s*')((?:[★◆◇]+\s)?)(\d+\.\s+)/g, '$1$2');

// 2) 토크 팝업 "썸 색인" → "기타 색인"
c2 = c2.replace(/💕 썸 색인/g, '💕 기타 색인');

// 3) 토크 팝업 가나다·알파벳순 색인 헤더 정리 (선택사항 — 그대로 둘 수도)
//    유지

// 4) 토크 팝업 H2 색상 #8b3a2a → #6b3a5e (지침 룰)
c2 = c2.replace(
  /var color = el\.tagName === 'H2' \? '#8b3a2a' : \(el\.tagName === 'H3' \? '#1a1a1a' : '#555'\);/,
  "var color = el.tagName === 'H2' ? '#6b3a5e' : (el.tagName === 'H3' ? '#1a1a1a' : '#555');"
);

// 5) 토크 팝업 빌드 — id 없으면 부모 section id fallback
c2 = c2.replace(
  /var id = el\.id;\s*if \(!id\) return;/,
  `var id = el.id;
       if (!id) {
         var parentSection = el.closest('section');
         if (parentSection && parentSection.id) id = parentSection.id;
       }
       if (!id) return;`
);

fs.writeFileSync(src, c2, 'utf8');

// 검증
const sumCount = (c2.match(/\['scene-|'prologue'|'ch\d+'/g) || []).length;
const seqCount = (c2.match(/\[\s*'[^']+',\s*'(?:[★◆◇]+\s)?\d+\.\s+/g) || []).length;
console.log(`sumScenes 항목: ${sumCount}건`);
console.log(`잔존 일련번호: ${seqCount}건`);
console.log(`"썸 색인" 잔존: ${(c2.match(/💕 썸 색인/g) || []).length}건`);
console.log(`"기타 색인" 등장: ${(c2.match(/💕 기타 색인/g) || []).length}건`);
