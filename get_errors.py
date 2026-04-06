import subprocess
print("Running dart analyze...")
result = subprocess.run(['dart', 'analyze'], capture_output=True, text=True)
errors = [line for line in result.stdout.split('\n') if 'error -' in line.lower()]
print(f"Found {len(errors)} errors")
for e in errors[:40]:
    print(e)
