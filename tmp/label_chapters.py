import re

src = r'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html'

with open(src, 'r', encoding='utf-8') as f:
    content = f.read()

ch_starts = []
for ch_num in [1, 2, 3]:
    idx = content.find(f'<h3 class="chapter" id="ch{ch_num}">')
    ch_starts.append(idx)

ch1_text = content[ch_starts[0]:ch_starts[1]]
ch2_text = content[ch_starts[1]:ch_starts[2]]

# 박스 클래스들 — 본문 흐름이 아닌 박스
BOX_CLASSES = ['case', 'check', 'side', 'keypoint', 'dialogue', 'cost', 'flow', 'ledger']

def label_chapter(text, ch_num):
    # 박스 영역 추출 (가장 안쪽까지 포함하기 위해 non-greedy + DOTALL)
    boxes = []
    box_pattern = re.compile(
        r'<div\s+class="(?:' + '|'.join(BOX_CLASSES) + r')"[^>]*>.*?</div>',
        re.DOTALL
    )

    def store_box(m):
        boxes.append(m.group(0))
        return f'\x00BOX{len(boxes)-1}\x00'

    text_no_boxes = box_pattern.sub(store_box, text)

    counter = [0]
    pattern = re.compile(r'<(p|blockquote\s+class="story")((?:\s[^>]*)?)>', re.IGNORECASE)

    def replacer(m):
        counter[0] += 1
        n = counter[0]
        tag_full = m.group(1)
        attrs = m.group(2) if m.group(2) else ''
        if re.search(r'\sid=', attrs, re.IGNORECASE):
            new_open = f'<{tag_full}{attrs}>'
        else:
            new_open = f'<{tag_full}{attrs} id="p{ch_num}-{n}">'
        label = f'<span style="color:#bbb;font-size:10px;font-weight:normal;margin-right:6px;">[#{ch_num}-{n}]</span>'
        return new_open + label

    labeled = pattern.sub(replacer, text_no_boxes)

    def restore(m):
        idx = int(m.group(1))
        return boxes[idx]

    labeled = re.sub(r'\x00BOX(\d+)\x00', restore, labeled)
    return labeled, counter[0]

new_ch1, c1 = label_chapter(ch1_text, 1)
new_ch2, c2 = label_chapter(ch2_text, 2)

new_content = content[:ch_starts[0]] + new_ch1 + new_ch2 + content[ch_starts[2]:]

with open(src, 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f'1장 본문 흐름 단락: {c1}')
print(f'2장 본문 흐름 단락: {c2}')
