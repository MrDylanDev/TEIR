import os
import glob

favicon_tag = '<link rel="shortcut icon" href="{% static \'IMG/Logo.jpg\' %}" type="image/x-icon">\n'

template_dir = r"c:\Users\aarga\Documents\TEM\templates"
updated_count = 0

for filepath in glob.glob(os.path.join(template_dir, '**', '*.html'), recursive=True):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    modified = False
    
    if '<head>' in content or '</head>' in content:
        # Ensure load static
        if '{% load static %}' not in content:
            lines = content.split('\n')
            insert_idx = 0
            for i, line in enumerate(lines):
                if '{% extends' in line:
                    insert_idx = i + 1
                    break
            lines.insert(insert_idx, '{% load static %}')
            content = '\n'.join(lines)
            modified = True

        # Ensure favicon
        if 'IMG/Logo.jpg' not in content and '</head>' in content:
            content = content.replace('</head>', f'    {favicon_tag}</head>')
            modified = True
            
        if modified:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            updated_count += 1
            print(f"Updated {filepath}")

print(f"Se actualizaron {updated_count} plantillas HTML exitosamente.")
