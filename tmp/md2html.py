import re, sys, os

def md_to_html(md_path, html_path):
    with open(md_path, 'r', encoding='utf-8') as f:
        md = f.read()

    # Extract title from first # heading
    title_match = re.search(r'^# (.+)$', md, re.MULTILINE)
    title = title_match.group(1) if title_match else 'Selftory'

    lines = md.split('\n')
    html_body = []

    for line in lines:
        stripped = line.strip()

        if not stripped:
            html_body.append('')
            continue

        # Headings
        if stripped.startswith('### '):
            text = stripped[4:]
            text = process_inline(text)
            html_body.append(f'<h3>{text}</h3>')
        elif stripped.startswith('## '):
            text = stripped[3:]
            text = process_inline(text)
            html_body.append(f'<h2>{text}</h2>')
        elif stripped.startswith('# '):
            text = stripped[2:]
            text = process_inline(text)
            html_body.append(f'<h1>{text}</h1>')
        elif stripped == '---':
            html_body.append('<hr>')
        elif stripped.startswith('> '):
            text = stripped[2:]
            text = process_inline(text)
            html_body.append(f'<blockquote>{text}</blockquote>')
        elif stripped.startswith('**') and stripped.endswith('**') and len(stripped) > 4:
            text = stripped[2:-2]
            html_body.append(f'<p class="bold">{text}</p>')
        else:
            text = process_inline(stripped)
            html_body.append(f'<p>{text}</p>')

    body_content = '\n'.join(html_body)

    html = f'''<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title} — Selftory</title>
<style>
  * {{ margin: 0; padding: 0; box-sizing: border-box; }}
  body {{
    font-family: 'Noto Serif KR', 'Georgia', serif;
    background: #faf9f6;
    color: #2c2c2c;
    line-height: 1.9;
    max-width: 680px;
    margin: 0 auto;
    padding: 60px 24px 120px;
  }}
  h1 {{
    font-size: 28px;
    font-weight: 700;
    text-align: center;
    margin: 40px 0 16px;
    color: #6C5CE7;
  }}
  h2 {{
    font-size: 20px;
    font-weight: 700;
    margin: 48px 0 12px;
    color: #6C5CE7;
    border-bottom: 1px solid #e0d8f0;
    padding-bottom: 8px;
  }}
  h3 {{
    font-size: 17px;
    font-weight: 700;
    margin: 36px 0 10px;
    color: #444;
  }}
  p {{
    margin: 12px 0;
    font-size: 15.5px;
    text-indent: 0;
  }}
  p.bold {{ font-weight: 700; }}
  blockquote {{
    margin: 16px 0;
    padding: 12px 20px;
    background: #f3f0ff;
    border-left: 3px solid #6C5CE7;
    border-radius: 0 8px 8px 0;
    font-style: italic;
    color: #555;
    font-size: 14.5px;
  }}
  hr {{
    border: none;
    border-top: 1px solid #e0e0e0;
    margin: 40px 0;
  }}
  em {{ font-style: italic; color: #666; }}
  strong {{ font-weight: 700; color: #333; }}

  /* Dialog style */
  p:has(+ p) {{ margin-bottom: 6px; }}

  /* Scrollbar */
  ::-webkit-scrollbar {{ width: 6px; }}
  ::-webkit-scrollbar-thumb {{ background: #ccc; border-radius: 3px; }}

  /* Footer */
  .footer {{
    text-align: center;
    margin-top: 60px;
    padding-top: 24px;
    border-top: 1px solid #e0e0e0;
    color: #999;
    font-size: 13px;
    font-style: italic;
  }}
  .footer .selftory {{ color: #6C5CE7; font-weight: 700; font-style: normal; }}

  @media (max-width: 720px) {{
    body {{ padding: 40px 18px 80px; }}
    h1 {{ font-size: 24px; }}
    p {{ font-size: 15px; }}
  }}
</style>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>

{body_content}

<div class="footer">
  <p>이 소설은 당신의 이야기입니다.</p>
  <p>당신이 주인공이고, 당신이 공동 작가입니다.</p>
  <p>다음 장을 쓰는 건, 당신의 몫입니다.</p>
  <p class="selftory">— Selftory</p>
</div>

</body>
</html>'''

    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f'Done: {html_path}')

def process_inline(text):
    # Bold **text**
    text = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', text)
    # Italic *text*
    text = re.sub(r'\*(.+?)\*', r'<em>\1</em>', text)
    return text

if __name__ == '__main__':
    base = 'd:/dev/selftory/docs'
    out = 'd:/dev/selftory/docs/html'

    files = [
        ('010.가디언_최종막장에디션.md', '010.가디언_최종막장에디션.html'),
        ('011.가디언_최종막장_확장판.md', '011.가디언_최종막장_확장판.html'),
        ('012.가디언_장편_최종막장.md', '012.가디언_장편_최종막장.html'),
    ]

    for md_name, html_name in files:
        md_to_html(os.path.join(base, md_name), os.path.join(out, html_name))
