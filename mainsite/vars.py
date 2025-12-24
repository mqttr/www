from os import environ

def global_vars(_):
    DOMAIN = environ.get('DOMAIN', 'example.com')
    return {
        'DOMAIN': DOMAIN,
        'EMAIL': {
            'SUFFIX': f'@{DOMAIN}',
            'CONTACT': f'contact@{DOMAIN}',
        },
        'LINK': {
            'DOMAIN': f'https://{DOMAIN}',
            'GITHUB': r'https://github.com/mqttr',
            'LINKED_IN': r'https://www.linkedin.com/in/matthew-roland/',
            'SELFHOSTED': {
                'VERSION_CONTROL_SYSTEM': f'https://www.git.{DOMAIN}',
                }
        },
    }

