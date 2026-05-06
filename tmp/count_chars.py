import re
import sys

# stdout UTF-8
sys.stdout.reconfigure(encoding='utf-8')

path = r'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
with open(path, 'r', encoding='utf-8') as f:
    html = f.read()

# Remove style and script blocks
no_style = re.sub(r'<style.*?</style>', '', html, flags=re.S)
no_script = re.sub(r'<script.*?</script>', '', no_style, flags=re.S)
# Remove tags
no_tags = re.sub(r'<[^>]+>', ' ', no_script)
# Remove HTML entities
no_ent = re.sub(r'&[a-zA-Z]+;', ' ', no_tags)
# Collapse whitespace
clean = re.sub(r'\s+', ' ', no_ent).strip()

total = len(clean)
no_space = len(clean.replace(' ', ''))
korean = len(re.findall(r'[가-힣]', clean))
english = len(re.findall(r'[a-zA-Z]', clean))
digits = len(re.findall(r'[0-9]', clean))

print('====== ERP Guide - Length Analysis ======')
print()
print(f'Total chars (with space)    : {total:,}')
print(f'Total chars (no space)      : {no_space:,}')
print(f'Korean chars                : {korean:,}')
print(f'English chars               : {english:,}')
print(f'Digit chars                 : {digits:,}')
print()
print('====== Page Estimate ======')
print()
print(f'Novel/Light book  (800 chars/page)   = {round(total/800)} pages')
print(f'Standard book     (1,000 chars/page) = {round(total/1000)} pages')
print(f'Tech/Practice     (1,200 chars/page) = {round(total/1200)} pages')
print(f'Dense reference   (1,500 chars/page) = {round(total/1500)} pages')
print()
print(f'200-char manuscript paper = {round(total/200):,} sheets')
print()
print('====== Reference ======')
print('- Typical Korean novel: 250-350 pages (200,000-280,000 chars)')
print('- Tech/practice book : 300-500 pages (300,000-600,000 chars)')
print('- Murakami Norwegian Wood: ~460 pages (~380,000 chars)')
