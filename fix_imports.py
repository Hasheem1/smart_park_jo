import os

def fix():
    for root, _, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                bad_import = "import 'package:flutter_gen/gen_l10n/app_localizations.dart';"
                good_import = "import 'package:flutter_gen/gen_l10n/app_localizations.dart';\nimport 'package:smart_park_jo/l10n/app_localizations.dart';"
                
                if bad_import in content:
                    # just replace the bad import entirely
                    content = content.replace(bad_import, "import 'package:smart_park_jo/l10n/app_localizations.dart';")
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Fixed {path}")

if __name__ == '__main__':
    fix()
