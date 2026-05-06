const fs = require('fs');
const path = require('path');

function processInline(text) {
  text = text.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  text = text.replace(/\*(.+?)\*/g, '<em>$1</em>');
  return text;
}

function mdToHtml(mdPath, htmlPath) {
  const md = fs.readFileSync(mdPath, 'utf-8');
  const titleMatch = md.match(/^# (.+)$/m);
  const title = titleMatch ? titleMatch[1] : 'Selftory';

  const lines = md.split('\n');
  const htmlBody = [];

  for (const line of lines) {
    const s = line.trim();
    if (!s) { htmlBody.push(''); continue; }
    if (s.startsWith('### ')) { htmlBody.push(`<h3>${processInline(s.slice(4))}</h3>`); }
    else if (s.startsWith('## ')) { htmlBody.push(`<h2>${processInline(s.slice(3))}</h2>`); }
    else if (s.startsWith('# ')) { htmlBody.push(`<h1>${processInline(s.slice(2))}</h1>`); }
    else if (s === '---') { htmlBody.push('<hr>'); }
    else if (s.startsWith('> ')) { htmlBody.push(`<blockquote>${processInline(s.slice(2))}</blockquote>`); }
    else { htmlBody.push(`<p>${processInline(s)}</p>`); }
  }

  const html = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${title} - Selftory</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    font-family: 'Noto Serif KR', Georgia, serif;
    background: #faf9f6; color: #2c2c2c;
    line-height: 1.9; max-width: 680px;
    margin: 0 auto; padding: 60px 24px 120px;
  }
  h1 { font-size: 28px; font-weight: 700; text-align: center; margin: 40px 0 16px; color: #6C5CE7; }
  h2 { font-size: 20px; font-weight: 700; margin: 48px 0 12px; color: #6C5CE7; border-bottom: 1px solid #e0d8f0; padding-bottom: 8px; }
  h3 { font-size: 17px; font-weight: 700; margin: 36px 0 10px; color: #444; }
  p { margin: 10px 0; font-size: 15.5px; }
  blockquote {
    margin: 16px 0; padding: 12px 20px;
    background: #f3f0ff; border-left: 3px solid #6C5CE7;
    border-radius: 0 8px 8px 0; font-style: italic; color: #555; font-size: 14.5px;
  }
  hr { border: none; border-top: 1px solid #e0e0e0; margin: 40px 0; }
  em { font-style: italic; color: #666; }
  strong { font-weight: 700; color: #333; }
  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-thumb { background: #ccc; border-radius: 3px; }
  .footer {
    text-align: center; margin-top: 60px; padding-top: 24px;
    border-top: 1px solid #e0e0e0; color: #999; font-size: 13px; font-style: italic;
  }
  .footer .brand { color: #6C5CE7; font-weight: 700; font-style: normal; }
  @media (max-width: 720px) { body { padding: 40px 18px 80px; } h1 { font-size: 24px; } p { font-size: 15px; } }
</style>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
${htmlBody.join('\n')}
<div class="footer">
<p>This story is yours.</p>
<p>You are the protagonist. You are the co-author.</p>
<p>The next chapter is up to you.</p>
<p class="brand">- Selftory</p>
</div>
</body>
</html>`;

  fs.writeFileSync(htmlPath, html, 'utf-8');
  console.log('Done: ' + htmlPath);
}

const base = 'd:/dev/selftory/docs';
const out = 'd:/dev/selftory/docs/html';

const files = [
  ['010.가디언_최종막장에디션.md', '010.가디언_최종막장에디션.html'],
  ['011.가디언_최종막장_확장판.md', '011.가디언_최종막장_확장판.html'],
  ['012.가디언_장편_최종막장.md', '012.가디언_장편_최종막장.html'],
];

for (const [mdName, htmlName] of files) {
  mdToHtml(path.join(base, mdName), path.join(out, htmlName));
}
