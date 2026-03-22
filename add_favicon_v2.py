import os

template_dir = r"c:\Users\aarga\Documents\TEM\templates"
updated = 0

for root_dir, dirs, files in os.walk(template_dir):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root_dir, file)
            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                modified = False
                
                if '</head>' in content and 'IMG/Logo.jpg' not in content:
                    if '{% load static %}' not in content:
                        # Insert load static
                        lines = content.split('\n')
                        insert_idx = 0
                        for i, line in enumerate(lines):
                            if '{% extends' in line:
                                insert_idx = i + 1
                                break
                        lines.insert(insert_idx, '{% load static %}')
                        content = '\n'.join(lines)
                    
                    # Insert favicon
                    favicon_tag = '<link rel="shortcut icon" href="{% static \'IMG/Logo.jpg\' %}" type="image/x-icon">\n'
                    content = content.replace('</head>', f'    {favicon_tag}</head>')
                    modified = True

                if modified:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    updated += 1
                    print(f"Updated {filepath}")
            except Exception as e:
                print(f"Error {filepath}: {e}")

print(f"Updated {updated} files total.")
