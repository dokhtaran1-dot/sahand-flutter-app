import zipfile
import re
from xml.etree import ElementTree as ET
path='assets/hogug/hogug.docx'
with zipfile.ZipFile(path) as z:
    root=ET.fromstring(z.read('word/document.xml'))
ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
paras=[]
for p in root.findall('.//w:p', ns):
    texts=[t.text for t in p.findall('.//w:t', ns) if t.text]
    if texts:
        paras.append(''.join(texts).strip())
notes=[]
for p in paras:
    m=re.match(r'نکته(\d+):\s*(.*)', p)
    if m:
        idx=int(m.group(1))
        body=m.group(2).strip()
        notes.append((idx, body))
notes.sort()
for idx, body in notes:
    title=body
    if '،' in title:
        title=title.split('،')[0]
    elif '.' in title:
        title=title.split('.')[0]
    title=title.strip()
    if len(title) > 30:
        title=' '.join(title.split()[:7])
    print(f'{idx}: {title}')
print('--- count', len(notes))
