import os, re, json

strings = set()
files_to_update = []

def extract():
    for root, _, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                    found_str = False
                    
                    # Text('...')
                    m1 = re.findall(r'Text\(\s*(["\'])(.*?)\1', content)
                    for m in m1: 
                        val = m[1]
                        if val.strip() and '$' not in val: 
                            strings.add(val)
                            found_str = True
                    
                    # hintText, labelText
                    m2 = re.findall(r'(?:hintText|labelText):\s*(["\'])(.*?)\1', content)
                    for m in m2: 
                        val = m[1]
                        if val.strip() and '$' not in val: 
                            strings.add(val)
                            found_str = True

                    if found_str or 'EdgeInsets.only' in content or 'Alignment.top' in content or 'Alignment.bottom' in content:
                        files_to_update.append(path)

    with open('strings_output.json', 'w', encoding='utf-8') as out:
        out.write(json.dumps({"strings": list(strings), "files": files_to_update}, indent=2))

if __name__ == '__main__':
    extract()
