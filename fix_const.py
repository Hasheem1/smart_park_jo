import re, os

def run():
    with open('errors.txt', 'r', encoding='utf-16le') as f:
        text = f.read()

    # error - lib/file.dart:178:37 - Invalid constant value
    matches = re.findall(r'error - (.*?):(\d+):\d+ - Invalid constant value', text)
    paths_fixed = set()
    for file_rel, line_str in matches:
        try:
            line_num = int(line_str) - 1 # 0-indexed
            
            # extract path properly
            path = file_rel.strip()
            if not os.path.exists(path):
                path = os.path.join(os.getcwd(), path)
            
            if not os.path.exists(path):
                continue
                
            with open(path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            # The error is 'Invalid constant value'. This usually means `const` is applied to a tree that has AppLocalizations.
            # We search backwards up to 10 lines from the error line to find 'const ' and remove it.
            for i in range(line_num, max(-1, line_num - 10), -1):
                if 'const ' in lines[i]:
                    lines[i] = lines[i].replace('const ', '')
                    paths_fixed.add(path)
                    break # remove the closest const
                    
            with open(path, 'w', encoding='utf-8') as f:
                f.writelines(lines)
        except Exception as e:
            print("Error fixing", file_rel, e)
            
            
    # let's also remove 'const AppLocalizations' if any
    for root, _, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                p = os.path.join(root, file)
                with open(p, 'r', encoding='utf-8') as f:
                    c = f.read()
                if 'const AppLocalizations' in c:
                    c = c.replace('const AppLocalizations', 'AppLocalizations')
                    with open(p, 'w', encoding='utf-8') as f:
                        f.write(c)
                        paths_fixed.add(p)

    print(f"Fixed consts in {len(paths_fixed)} files")

if __name__ == '__main__':
    run()
