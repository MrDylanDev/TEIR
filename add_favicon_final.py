import os

template_dir = r"c:\Users\aarga\Documents\TEM\templates"

for root_dir, dirs, files in os.walk(template_dir):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root_dir, file)
            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                modified = False
                
                if '</head>' in content and 'rel="shortcut icon"' not in content:
                    if '{% load static %}' not in content:
                        content = '{% load static %}\n' + content
                    
                    favicon_tag = '<link rel="shortcut icon" href="{% static \'IMG/Logo.jpg\' %}" type="image/x-icon">\n'
                    content = content.replace('</head>', f'    {favicon_tag}</head>')
                    modified = True

                if modified:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
            except Exception as e:
                pass
