import os
import re

def search():
    missed = []
    
    # Regex to match string literals (single or double quotes) containing at least one alphabetical character.
    # Excludes empty strings or purely numeric strings.
    string_regex = re.compile(r'(["\'])([a-zA-Z][^\'"]*?)\1')
    
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                
                # Skip localization or generated files
                if 'l10n' in filepath or 'firebase_options.dart' in filepath:
                    continue
                    
                with open(filepath, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    
                for idx, line in enumerate(lines):
                    # Strip comments
                    line_uncommented = line.split('//')[0].strip()
                    if not line_uncommented:
                        continue
                        
                    # Find all string literals
                    matches = string_regex.findall(line_uncommented)
                    for match in matches:
                        string_val = match[1].strip()
                        
                        # Filter out common non-UI strings (routes, keys, ids, hex colors, pure symbols)
                        if len(string_val) < 2: continue
                        if string_val.startswith('package:'): continue
                        if string_val.startswith('assets/'): continue
                        if string_val.lower() in ['get', 'post', 'put', 'delete', 'pending', 'available', 'occupied', 'en', 'ar']: continue
                        if string_val.endswith('.png') or string_val.endswith('.jpg') or string_val.endswith('.xml'): continue
                        if len(string_val) == 20: continue # Likely an ID
                        
                        # Only report strings that look like human-readable text (has spaces or uppercase start)
                        # We also want to catch things like "Full Name", "Please confirm password", etc.
                        if ' ' in string_val or string_val[0].isupper():
                            # Check if it's already an AppLocalization usage (sometimes strings are passed as keys)
                            if 'AppLocalizations' not in line_uncommented:
                                missed.append(f"{filepath}:{idx + 1}: {string_val[:50]}  ---> {line_uncommented}")

    with open('missed_strings.txt', 'w', encoding='utf-8') as f:
        for m in missed:
            f.write(m + '\n')
            
    print(f"Found {len(missed)} potential missed strings.")

if __name__ == '__main__':
    search()
